//
//  MainView.swift
//  CMWeather46
//
//  Created by Rai on 2023/01/19.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView() {
            CurrentLocatonView()
            CustomLocaionView()
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
