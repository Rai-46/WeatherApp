//
//  CMWeather46App.swift
//  CMWeather46
//
//  Created by Rai on 2023/01/13.
//

import SwiftUI

@main
struct CMWeather46App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(MonitoringNetworkState())
        }
    }
}
let properties = Prop.shared.properties
