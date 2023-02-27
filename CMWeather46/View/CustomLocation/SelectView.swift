//
//  SelectView.swift
//  CMWeather46
//
//  Created by Rai on 2023/01/19.
//

import SwiftUI

struct SelectView: View {
    @Binding var isShowSheet: Bool
    @Binding var selected: Bool
    @Binding var selectCidy: String
    
    var viewModel: CustomLocationViewModel
    
    struct Ken: Hashable, Identifiable, CustomStringConvertible {
        var id: Self {self}
        var name: String
        var children: [Ken]? = nil
        var description: String {
            switch children {
            case nil:
                return name
            case .some(_):
                return name
            }
        }
    }
    
    let itemData: [Ken] = [
        Ken(name: "群馬県", children: [Ken(name: "前橋市"), Ken(name: "高崎市"), Ken(name: "伊勢崎市")]),
        Ken(name: "栃木県", children: [Ken(name: "宇都宮市"), Ken(name: "小山市"), Ken(name: "日光市")]),
        Ken(name: "茨城県", children: [Ken(name: "水戸市"), Ken(name: "つくば市"), Ken(name: "日立市")]),
        Ken(name: "埼玉県", children: [Ken(name: "さいたま市"), Ken(name: "熊谷市"), Ken(name: "秩父市")]),
        Ken(name: "東京都", children: [Ken(name: "新宿区"), Ken(name: "八王子市"), Ken(name: "日立市")]),
        Ken(name: "神奈川県", children: [Ken(name: "横浜市"), Ken(name: "川崎市"), Ken(name: "横須賀市")])
    ]
    
    
    
    var body: some View {
        ZStack {
            
            List(itemData, children: \.children) { item in
                if item.children == nil {
                    Button {
                        selected = true
                        selectCidy = item.description
                        isShowSheet.toggle()
                        
                        viewModel.getWeather(place: item.description)
                        
                    } label: {
                        Text(item.description)
                    }

                } else {
                    Text(item.description)
                }
            }
            
        }
        .presentationDetents([.medium])
    }
}

//struct SelectView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectView()
//    }
//}
