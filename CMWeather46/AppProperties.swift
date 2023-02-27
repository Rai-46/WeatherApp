//
//  AppProperties.swift
//  CMWeather46
//
//  Created by Rai on 2023/01/19.
//

import Foundation

typealias Prop = AppProperties
class AppProperties {
    static let shared: Prop = .init()
    
    let properties: [String : String]
    
    private init() {
        if let path = Bundle.main.path(forResource: "Properties", ofType: "plist"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let plist = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as?
            [String : String] {
            properties = plist
        } else {
            properties = [:]
        }
    }
}
