//
//  WeekView.swift
//  CMWeather46
//
//  Created by Rai on 2023/01/20.
//

import SwiftUI

struct WeekView: View {
    
    var date: Int
    var max: Double
    var min: Double
    var icon: String
    var pop: Double
    
    var body: some View {
        HStack {
            Text(dataformatter(date:date))
            Image(icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
            Spacer()
            Text("\((Int)(round((max * 100)/100)))℃")
                .foregroundColor(Color.red)
            Spacer()
            Text("\((Int)(round((min * 100)/100)))℃")
                .foregroundColor(Color.blue)
            Spacer()
            Text("\((Int)(pop * 100))%")
        }
    }
    
    func dataformatter(date: Int) -> String {
        //プロパティに入れる処理
        let time = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        
        return dateFormatter.string(from: time)
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(date: 1674205200, max: 15.1, min: 5.3, icon: "03n", pop: 0)
    }
}
