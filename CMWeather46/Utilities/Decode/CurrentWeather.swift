//
//  CurrentWeather.swift
//  CMWeather46
//
//  Created by Rai on 2023/01/19.
//

import Foundation

struct CurrentWeather: Decodable {
    
    let coord: Coord
        struct Coord: Decodable {
            let lat: Double // 経度
            let lon: Double // 緯度
        }
    let weather: [Weather]
        struct Weather: Decodable {
            let id: Int // 天気のID（800番台は....)
            let description: String // 天気情報（薄い雲）
            let icon: String // アイコンID
        }
    let main: Main
        struct Main: Decodable {
            let temp: Double // 現在の気温
            let temp_max: Double // 現時点での最高気温
            let temp_min: Double // 現時点での最低気温
        }
}
