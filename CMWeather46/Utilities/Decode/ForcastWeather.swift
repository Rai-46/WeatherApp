//
//  ForcastWeather.swift
//  CMWeather46
//
//  Created by Rai on 2023/01/20.
//

import Foundation

struct ForecaseWeather : Decodable {
    
    let list : [List]
    struct List: Decodable {
        let dt: Int
        let main: Main
        let weather: [Weather]
        let pop: Double
    }
    
    struct Main: Decodable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
    }
    
    struct Weather: Decodable {
        let icon: String
    }
}

struct ForecastList: Identifiable {
    let id = UUID()
    let dt: Int
    let main: Main
    let weather: [Weather]
    let pop: Double
    
    struct Main {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
    }
    
    struct Weather {
        let icon: String
    }
}
