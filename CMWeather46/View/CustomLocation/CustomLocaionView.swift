//
//  CustomLocaion.swift
//  CMWeather46
//
//  Created by Rai on 2023/01/19.
//

import SwiftUI

struct CustomLocaionView: View {
    
    @State var isShowSelectView: Bool = false
    @State var selected: Bool = false
    @State var selectCity: String = ""
    
    @ObservedObject var viewModel = CustomLocationViewModel()
    
    var body: some View {
        
        VStack {
            
            if selected {
                
                if let currentWeather = viewModel.currentWeather, let forecastWeatherItem = viewModel.forecastWeatherItem  {
                    BaseView(place: selectCity, icon: currentWeather.weather[0].icon,
                             templeture: currentWeather.main.temp,
                             maxTemp: currentWeather.main.temp_max,
                             minTemp: currentWeather.main.temp_min,
                             forecastWeather: forecastWeatherItem)
                } else {
                    
                    Spacer()
                    ProgressView()
                    Spacer()
                    
                }
                
            } else {
                Spacer()
                Text("取得したい地点を指定してください。")
                Spacer()
                
            }
            
            
            Button {
                isShowSelectView.toggle()
            } label: {
                Text("都市選択")
                    .padding(.bottom, 30)
            }
            
            
            
        }.sheet(isPresented: $isShowSelectView) {
            SelectView(isShowSheet: $isShowSelectView, selected: $selected, selectCidy: $selectCity, viewModel: viewModel)
            
        }
    }
}

struct CustomLocaionView_Previews: PreviewProvider {
    static var previews: some View {
        CustomLocaionView()
    }
}
