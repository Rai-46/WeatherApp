//
//  Error.swift
//  CMWeather46
//
//  Created by Rai on 2023/01/20.
//

import Foundation

enum ResError: Error {
    case urlError
    case fetchError
    case parseError
    case encodeError
    
    var message: String {
        switch self {
        case .urlError:
            return "URLが正しくありません。"
        case .fetchError:
            return "jsonの取得に失敗しました。\n時間を置いて試してください"
        case .parseError:
            return "パースエラー"
        case .encodeError:
            return ""
        }
    }
}
