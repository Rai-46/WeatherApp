//
//  CurrentLocationViewModel.swift
//  CMWeather46
//
//  Created by Rai on 2023/01/19.
//

import Foundation
import CoreLocation

// ほぼ写経失礼致します。
class CurrentLocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var lastSeenLocation: CLLocation?
    private let locationManager: CLLocationManager
    
    // 現在の天気
    @Published var currentWeather: CurrentWeather?
    // 週間予報
//    @Published var forecastWeather: ForecaseWeather?
    @Published var forecastWeatherItem : [ForecastList]? = []
    // apikey
    private var apikey: String = ""
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.allowsBackgroundLocationUpdates = true // バックグラウンド実行中も座標取得する場合、trueにする
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
        
        guard let apikey = properties["apikey"] else {
            fatalError()
        }
        self.apikey = apikey
        
    }
    
    // 天気を取得する
    func getLocation(lon: CLLocationDegrees, lat: CLLocationDegrees) {
        
        print("緯度\(lon)")
        
        do {
            // 現在の天気取得
            try getCurrentWeather(lon: lon, lat: lat)
            // 週間予報取得
            try getForecastWeather(lon: lon, lat: lat)
            
        } catch {
            // FIXME: エラー処理
            print("getLocation:error")
        }
        
    }
    
    // 座標のコーディネート？
    var coordinate: CLLocationCoordinate2D? {
        lastSeenLocation?.coordinate
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestAlwaysAuthorization() // バックグラウンド実行中も座標取得する場合はこちら
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
    }
    
    @Published var i = 0
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastSeenLocation = locations.first
        
        print("didupdateLocations")
        
        
        if i == 0 {
            getLocation(lon: lastSeenLocation?.coordinate.longitude ?? 0, lat: lastSeenLocation?.coordinate.latitude ?? 0)
            i += 1
        }
        // タイマーでCLLocation切る
        
    }
    
    // getCurrentWeather
    func getCurrentWeather(lon: CLLocationDegrees, lat: CLLocationDegrees) throws {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather") else {
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
                    let result = try JSONDecoder().decode(CurrentWeather.self, from: data)
                    
                    await MainActor.run {
                        currentWeather = CurrentWeather(coord: result.coord, weather: result.weather, main: result.main)
                    }
                    
                } catch {
                    print(error)
                    print("でこーどえらー！")
                    
                }
            }
        }
    }
    
    func getForecastWeather(lon: CLLocationDegrees, lat: CLLocationDegrees) throws {
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
