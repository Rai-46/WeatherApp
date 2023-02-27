//
//  CurrentLocatonView.swift
//  CMWeather46
//
//  Created by Rai on 2023/01/19.
//

import SwiftUI
import CoreLocation

struct CurrentLocatonView: View {
    
    @StateObject var viewModel = CurrentLocationViewModel()
    
    var apikey: String
    
    init() {
        guard let apikey = properties["apikey"] else {
            fatalError()
        }
        self.apikey = apikey
        
    }
    
    var body: some View {
        switch viewModel.authorizationStatus {
        case .notDetermined:
            RequestLocationView()
                .environmentObject(viewModel)
        case .restricted:
            Text("位置情報の使用が制限されています。")
        case .denied:
            Text("位置情報を使用できません。")
        case .authorizedAlways, .authorizedWhenInUse:
            // TODO : ここでBaseViewを表示（座標に合わせた天気View）
            
            if let currentWeather = viewModel.currentWeather, let forecastWeatherItem = viewModel.forecastWeatherItem  {
                BaseView(place: "現在地", icon: currentWeather.weather[0].icon,
                         templeture: currentWeather.main.temp,
                         maxTemp: currentWeather.main.temp_max,
                         minTemp: currentWeather.main.temp_min,
                         forecastWeather: forecastWeatherItem)
            } else {
                //                Text("データが取得できませんでした")
                ProgressView()
                
            }
            
            
            
        default:
            Text("Unexpected status")
        }
        
        
        
    }
}

struct RequestLocationView: View {
    @EnvironmentObject var viewModel: CurrentLocationViewModel
    
    var body: some View {
        Button(action: {
            viewModel.requestPermission()
        }) {
            Text("位置情報の使用を許可する")
        }
    }
}

struct CurrentLocatonView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentLocatonView()
    }
}
