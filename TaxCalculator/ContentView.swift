//
//  ContentView.swift
//  TaxCalculator
//
//  Created by Takeshi Sakamoto on 2024/11/02.
//

import SwiftUI

class TaxCalculatorViewModel: ObservableObject {
    //状態を管理する変数
    @Published var inputText: String = ""
    @Published var calculatedTax = 0.0
    @Published var showError = false
    @Published var errorMessage: String = ""
    @Published var selectedTaxRate = 0.10
    
    //数値フォーマッター
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter
    }()
    
    //税率計算関数
    func calculateTax() {
        //カンマを除去して数値に変換
        guard let input = Double(inputText.replacingOccurrences(of: ",", with: ""))else {
            showError = true
            errorMessage = "有効な数値を入力してください"
            return
        }
        //不の値チェック
        if input < 0 {
            showError = true
            errorMessage = "正の数値を入力してください"
            return
        }
        //税額の計算（小数点未満切り捨て）
        calculatedTax = floor(input * (1 + selectedTaxRate))
    }
    
    // 数値フォーマットメソッド
    func formatNumber(_ value: String) -> String {
        if let number = Int(value.replacingOccurrences(of: ",", with: "")) {
            return numberFormatter.string(from: NSNumber(value: number)) ?? value
        }
        return value
    }
}

struct ContentView: View {
    @StateObject private var viewModel = TaxCalculatorViewModel()
    
    var body: some View {
        VStack (spacing: 20){
            Text("消費税計算アプリ")
                .font(.largeTitle)
                .padding(.top, 100)
                .padding(.bottom, 50)
                .accessibilityAddTraits(.isHeader)
            
            Picker("税率", selection: $viewModel.selectedTaxRate) {
                Text("10%").tag(0.10)
                Text("8%").tag(0.08)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 20)
            
            TextField("価格を入力",text: $viewModel.inputText)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal,20)
                .accessibilityLabel("価格入力フィールド")
            
            Button(action: viewModel.calculateTax){
                Text("計算")
                .bold()
                .frame(width: 100, height: 50)
                .foregroundColor(Color.white)
                .background(Color.orange)
                .cornerRadius(10)
            }
            .padding(10)
            .accessibilityHint("タップすると消費税を計算します")
            
            VStack(spacing: 15){
                HStack {
                    Text("金額\u{300}\u{300}\u{300}：")
                    Text("\(viewModel.formatNumber(viewModel.inputText))")
                        .frame(width: 200, alignment: .trailing)
                        .lineLimit(1)
                    Text("円")
                }
                
                HStack {
                    Text("消費税込み：")
                    Text(viewModel.calculatedTax == 0.0 ? "" : "\(Int(viewModel.calculatedTax))")
                        .frame(width: 200, alignment: .trailing)
                        .lineLimit(1)
                    Text("円")
                }
            }
            .accessibilityElement(children: .combine)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // 画面全体を埋める
        .background(Color.green.opacity(0.3)) // 薄いグリーンに設定
        .edgesIgnoringSafeArea(.all) // セーフエリアを無視して背景を広げる
        
        //エラーアラート
        .alert("エラー", isPresented: $viewModel.showError) {
            Button("OK") {
                viewModel.showError = false
            }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}
#Preview {
    ContentView()
}
