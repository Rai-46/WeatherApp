//
//  ContentView.swift
//  CMWeather46
//
//  Created by Rai on 2023/01/13.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var networkState: MonitoringNetworkState
    
    var body: some View {
        if networkState.isConnected {
            MainView()
        } else {
            Text("インターネット接続を確認してください")
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
