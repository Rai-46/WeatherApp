//
//  Fetcher.swift
//  CMWeather46
//
//  Created by Rai on 2023/01/19.
//

import Foundation

class Fetcher {
    private init() {}
    
    enum FetchError: Error {
        case networkError
        case statusError
    }
    
    /// - Parameters:
    ///   - url: 取得したいJSONのURL。パラメータは付与された状態で渡すこと
    ///   - session: 指定がない場合はnil。
    ///   - handler: データを取得後の処理
    /// - Returns: データとエラーステータス
    static func fetch(from url: URL, session: URLSession? = nil) async -> Result<Data, Error> {

        // リクエストを作成してfetch(from:session:handler:)に投げる
        let request = URLRequest(url: url)
        return await self.fetch(from: request, session: session)

    }
    
    /// - Parameters:
    ///   - request: 設定済みのrequest
    ///   - session: 指定がない場合はnil。（Post？）
    ///   - handler: データ取得後の処理
    /// - Returns: データとエラーステータス
    static func fetch(from request: URLRequest, session: URLSession? = nil) async -> Result<Data, Error> {
        let session = (session == nil) ? URLSession(configuration: .default) : session!

        do {
            // awaitを使う 非同期（別スレッド）で実行中(response : 404とか)
            // ここでJSONを取ってくる！
            let (data, response) = try await session.data(for: request)

            guard let response = response as? HTTPURLResponse else {
                print("network")

                // networkError
                return .failure(FetchError.networkError)
            }
            
            print(response.statusCode)
            
            // レスポンスステータスコードによるエラーハンドリング
            if !(200...299).contains(response.statusCode),
                !(300...399).contains(response.statusCode) {
                if response.statusCode == 404 {
                    if !data.isEmpty {
                        return .success(data)

                    } else {
                        return .failure(FetchError.statusError)
                    }
                } else {
                    // ガチエラー
                    print("ステータスコードが正常ではありません： \(response.statusCode)")
                    return .failure(FetchError.statusError)
                }
            }
            return .success(data) // data = jsondata
        } catch(let error) {
            print("catchError")
            return Result.failure(error)
        }
    }
}

