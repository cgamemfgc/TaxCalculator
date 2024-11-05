//
//  ContentView.swift
//  TaxCalculator
//
//  Created by Takeshi Sakamoto on 2024/11/02.
//

import SwiftUI

struct ContentView: View {
    @State var inputText = ""
    @State var tax8 = 0.0
    @State var tax10 = 0.0
    var body: some View {
        VStack (spacing: 20){
            TextField("価格を入力",text: $inputText).keyboardType(.numberPad)
            Button("計算"){
                tax8 = (Double(inputText) ?? 0) * 0.08
                tax10 = (Double(inputText) ?? 0) * 0.1
            }
            Text("価格：\(inputText)")
            Text("消費税8%：\(tax8)")
            Text("消費税10%：\(tax10)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
