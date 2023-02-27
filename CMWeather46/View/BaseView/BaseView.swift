//
//  BaseView.swift
//  CMWeather46
//
//  Created by Rai on 2023/01/19.
//

import SwiftUI

struct BaseView: View {
    
    // 場所
    var place: String = ""
    // アイコン
    var icon: String
    // 現在気温
    var templeture: Double
    // 最高気温
    var maxTemp: Double
    // 最低気温
    var minTemp: Double
    
    var forecastWeather: [ForecastList]
    
    
    var body: some View {
        VStack {
            VStack {
                Text(place)
                    .font(.largeTitle)
                
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                
                Text("\(String((Int)(round((templeture * 100)/100)))) °C")
                    .font(.title)
                
                HStack {
                    Text("\(String((Int)(round((maxTemp * 100)/100)))) °C")
                        .foregroundColor(.red)
                    
                    Text(" / ")
                    
                    Text("\(String((Int)(round((minTemp * 100)/100)))) °C")
                        .foregroundColor(.blue)
                }
                .padding()
               
                
            }
//            .frame(width: UIScreen.main.bounds.width)
//            .background(Color.cyan)
            
            List {
                Text("5日間予報")
                    .font(.title2)
                
                ForEach(forecastWeather) { weather in
                    WeekView(date: weather.dt, max: weather.main.temp_max, min: weather.main.temp_min, icon: weather.weather[0].icon, pop: weather.pop)
                }
                
            }
            
        }
    }
}

//struct BaseView_Previews: PreviewProvider {
//    static var previews: some View {
//        BaseView(place: "", icon: "02d", templeture: 9.0, maxTemp: 12.0, minTemp: 4, forecastWeather: [ForecaseWeather(list: nil)])
//    }
//}
