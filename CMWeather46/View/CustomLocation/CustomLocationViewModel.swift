//
//  CustomLocationViewModel.swift
//  CMWeather46
//
//  Created by Rai on 2023/01/20.
//

import Foundation

class CustomLocationViewModel: ObservableObject {
    // 現在の天気
    @Published var currentWeather: CurrentWeather?
    // 週間予報
    @Published var forecastWeatherItem : [ForecastList]? = []
    
    private var apikey: String
    
    init() {
        
        guard let apikey = properties["apikey"] else {
            fatalError()
        }
        self.apikey = apikey
        
        
    }
    
    func getWeather(place: String) {
        do {
            try getCurrentWeather(place: place)
        } catch {
            print("CustomLocationViewModelでエラー")
        }
    }
    
    // HTTPリクエストを投げる
    func getCurrentWeather(place: String) throws {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather") else {
            print("getCurrentWeatherでurlが間違っています")
            throw ResError.urlError
        }
        
        guard let kenmei_encode = place.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        print("けんめいエンコーど" + kenmei_encode)
        
        // パラメータの作成
        let queryItems: [URLQueryItem] = [.init(name: "q", value: place), .init(name: "appid", value: apikey), .init(name: "lang", value: "ja"), .init(name: "units", value: "metric")]
        
        // URLComponentsの作成
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return
        }
        components.queryItems = queryItems
        guard let queryStringAddedUrl = components.url else {
            return
        }
        
        print(queryStringAddedUrl)
        
        Task {
            let request = URLRequest(url: queryStringAddedUrl)
            print("reqいけてる")
            let result = await Fetcher.fetch(from: request)
            
            switch result {
            case .failure(let error):
                // FIXME: エラー処理
                print("error\(error)")
                
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(CurrentWeather.self, from: data)
                    
                    await MainActor.run {
                        currentWeather = CurrentWeather(coord: result.coord, weather: result.weather, main: result.main)
                        
                        do {
                            try getForecastWeather(lat: Int(result.coord.lat), lon: Int(result.coord.lon))
                        } catch {
                            print("getForecastWeatherでリクエストエラー")
                        }
                        
                    }
                    
                } catch {
                    print(error)
                    print("でこーどえらー！")
                    
                }
            }
        }
    }
    
    func getForecastWeather(lat: Int, lon: Int) throws {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast") else {
            print("getCurrentWeatherでurlが間違っています")
            throw ResError.urlError
        }
        
        // パラメータの作成
        let queryItems: [URLQueryItem] = [.init(name: "lon", value: String(lon)), .init(name: "lat", value: String(lat)), .init(name: "appid", value: apikey), .init(name: "lang", value: "ja"), .init(name: "units", value: "metric")]
        
        // URLComponentsの作成
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return
        }
        components.queryItems = queryItems
        guard let queryStringAddedUrl = components.url else {
            return
        }
        
        print(queryStringAddedUrl)
        
        Task {
            let request = URLRequest(url: queryStringAddedUrl)
            print("reqいけてる")
            let result = await Fetcher.fetch(from: request)
            
            switch result {
            case .failure(let error):
                // FIXME: エラー処理
                print("error\(error)")
                
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(ForecaseWeather.self, from: data)
                    
                    await MainActor.run {
                        self.forecastWeatherItem?.removeAll()
                        // 今は全て格納している
                        for item in result.list {
                            
                            // 昼の12時だけをappend
                            let time = Date(timeIntervalSince1970: TimeInterval(item.dt))
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "HH"
                            
                            let itemTime = dateFormatter.string(from: time)
                            
                            // その日の12時の情報だけ追加
                            if(Int(itemTime) == 12) {
                                
                                let list = ForecastList(dt: item.dt, main: ForecastList.Main(temp: item.main.temp, temp_min: item.main.temp_min, temp_max: item.main.temp_max), weather: [ForecastList.Weather(icon: item.weather[0].icon)], pop: item.pop)
                                self.forecastWeatherItem?.append(list)
                            }
                        }
                    }
                    
                } catch {
                    print(error)
                    print("でこーどえらー！")
                    
                }
            }
        }
    }
}
