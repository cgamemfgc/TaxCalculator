//
//  ContentView.swift
//  TaxCalculator
//
//  Created by Takeshi Sakamoto on 2024/11/02.
//

import SwiftUI

struct ContentView: View {
    @State var inputText = ""
    @State var tax10 = 0.0
    
    private let numberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter
    }()
    
    private func formatNumber(_ value: String) -> String {
        if let number = Int(value) {
                    return numberFormatter.string(from: NSNumber(value: number)) ?? value
                }
        return value
    }
    
    var body: some View {
        VStack (spacing: 20){
            Text("消費税計算アプリ")
                .font(.largeTitle)
                .padding(.top, 100)
                .padding(.bottom, 100)
            
            TextField("価格を入力",text:$inputText)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal,20)
            
            Button("計算"){
                let input = Double(inputText) ?? 0
                tax10 = floor(input * 1.1)
            }
                .bold()
                .frame(width: 100, height: 50)
                .foregroundColor(Color.white)
                .background(Color.orange)
                .cornerRadius(10)
                .padding(10)
            HStack(){
                Text("金額　　　：")
                Text("\(formatNumber(inputText))円")
            }
            HStack(){
                Text("消費税10％：")
                Text(tax10 == 0.0 ?  "" : "\(Int(tax10))円")
            }
            Spacer()
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity) // 画面全体を埋める
        .background(Color.green.opacity(0.3)) // 薄いグリーンに設定
        .edgesIgnoringSafeArea(.all) // セーフエリアを無視して背景を広げる
    }
}

#Preview {
    ContentView()
}
