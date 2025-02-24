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
    @Published var showResult: Bool = false
    
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
        //負の値チェック
        if input < 0 {
            showError = true
            errorMessage = "正の数値を入力してください"
            return
        }
        //税額の計算（小数点未満切り捨て）
        calculatedTax = floor(input * (1 + selectedTaxRate))
        withAnimation{
            showResult = true
        }
    }
    
    // 数値フォーマットメソッド
    func formatNumber(_ value: String) -> String {
        if let number = Int(value.replacingOccurrences(of: ",", with: "")) {
            return numberFormatter.string(from: NSNumber(value: number)) ?? value
        }
        return value
    }
    
    // inputTextの監視
    func onInputTextChenge(){
        if inputText.isEmpty {
            showResult = false
        }
    }
}


struct AmountDisplayView: View {
    let title: String
    let amount: String
    let isTotal: Bool
    
    var body: some View {
        HStack{
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(amount)
                    .font(isTotal ? .title3.bold() : .headline)
                    .foregroundColor(isTotal ? .blue: .primary)
                Text("円")
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title) \(amount)円")
    }
}
    
struct ContentView: View {
    @StateObject private var viewModel = TaxCalculatorViewModel()
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                // 価格入力セクション
                Section {
                    TextField("価格を入力",text: $viewModel.inputText)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($isInputFocused)
                        .onChange(of: viewModel.inputText) { oldValue, newValue in if !newValue.isEmpty {
                            viewModel.inputText = viewModel.formatNumber(newValue)
                            }
                            viewModel.onInputTextChenge()
                        }
                        .accessibilityLabel("価格を入力")
                } header: {
                    Text("価格")
                }
                // 税率選択セクション
                Section {
                    Picker("税率", selection: $viewModel.selectedTaxRate) {
                        Text("10%").tag(0.10)
                        Text("8%").tag(0.08)
                    }
                    .pickerStyle(.segmented)
                    .accessibilityLabel("税率選択")
                } header: {
                    Text("税率")
                }
                
                // 計算ボタン
                Section{
                    Button(action: {
                        isInputFocused = false
                        viewModel.calculateTax()
                    }){
                        Text("計算する")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(viewModel.inputText.isEmpty)
                }
                
                // 計算結果セクション
                if viewModel.showResult {
                    Section {
                        AmountDisplayView(
                            title: "税抜金額",
                            amount: viewModel.formatNumber(viewModel.inputText),
                            isTotal: false
                        )
                        
                        AmountDisplayView(
                            title:"税込金額",
                            amount: viewModel.formatNumber(String(Int(viewModel.calculatedTax))),
                            isTotal: true
                        )
                    }
                }
            }
            .navigationTitle("消費税計算")
            .alert("エラー", isPresented: $viewModel.showError) {
                Button("OK") {
                    viewModel.showError = false
                }
            } message: {
                Text(viewModel.errorMessage)
            }
            .toolbar {
                if isInputFocused {
                    Button("完了") {
                        isInputFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
        
//        VStack (spacing: 20){
//            Text("消費税計算アプリ")
//                .font(.largeTitle)
//                .padding(.top, 20)
//                .padding(.bottom, 50)
//                .accessibilityAddTraits(.isHeader)
//            
//            
//            .pickerStyle(SegmentedPickerStyle())
//            .padding(.horizontal, 20)
//            
//            
//            Button(action: viewModel.calculateTax){
//                Text("計算")
//                    .bold()
//                    .frame(width: 100, height: 50)
//                    .foregroundColor(Color.white)
//                    .background(Color.orange)
//                    .cornerRadius(10)
//            }
//            .padding(10)
//            .accessibilityHint("タップすると消費税を計算します")
//            
//            resultView
//            
//            Spacer()
//        }
//                .frame(maxWidth: .infinity, maxHeight: .infinity) // 画面全体を埋める
//                .background(Color.green.opacity(0.3)) // 薄いグリーンに設定
////                .edgesIgnoringSafeArea(.all) // セーフエリアを無視して背景を広げる
//            
//            //エラーアラート
//                .alert("エラー", isPresented: $viewModel.showError) {
//                    Button("OK") {
//                        viewModel.showError = false
//                    }
//                } message: {
//                    Text(viewModel.errorMessage)
//                }
//        }
//        
//    var resultView: some View {
//        VStack(spacing: 15){
//            AmountDisplayView(
//                title: "税抜金額",
//                amount: viewModel.formatNumber(viewModel.inputText),
//                isTotal: false
//            )
//            Rectangle()
//                .frame(width: 0, height: 40)
//                .foregroundColor(Color.gray.opacity(0.2))
//            
//            AmountDisplayView(
//                title: "税込金額",
//                amount: viewModel.calculatedTax == 0.0 ? "" : viewModel.formatNumber( "\(Int(viewModel.calculatedTax))"),
//                isTotal: true
//            )
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(12)
//        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 2)
//        .padding(.horizontal, 20)
//        }
//    }


