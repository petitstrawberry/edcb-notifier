//
//  main.swift
//  edcb-notifier
//
//  Created by petitstrawberry on 2023/05/26.
//

// Usage: edcb-notifier <webhook url>
// Example: edcb-notifier https://n8n.example.com/webhook/edcb-rec-end

import Foundation

#if !(os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
import FoundationNetworking // 非Darwin環境でURLSessionを使うために必要
#endif
import EDCBEnv
import ArgumentParser

@main
struct EDCBNotifier: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "edcb-notifier",
        version: "1.0.0",
        shouldDisplay: true,
        helpNames: [.long, .short]
    )

    @Argument(help: "Webhook URL")
    var url: String

    @Option(help: "timeout seconds")
    var timeout: Int = 10

    mutating func run() throws {
        // urlにpostして、結果を表示する
        // ただし, タイムアウトするかレスポンスが返るまで待機
        let semaphore = DispatchSemaphore(value: 0)
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.timeoutInterval = TimeInterval(timeout)

        // EDCBから渡される環境変数を取得
        let edcbenv = EDCBEnv()

        // dataをJSONに変換
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(edcbenv)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data, let response = response as? HTTPURLResponse {
                print("Response: \(response.statusCode)")
                print(String(data: data, encoding: .utf8)!)
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
}