//
//  ContentView.swift
//  WeSplit
//
//  Created by Alberto Peinado Santana on 10/8/23.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount: Double?
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 2
    
    @FocusState private var amountIsFocused: Bool
    
    // Formatting in 2 ways
    private let userCurrency = Locale.current.currency?.identifier ?? "EUR"
    private let currencyType: FloatingPointFormatStyle<Double>.Currency = FloatingPointFormatStyle.Currency.currency(code: Locale.current.currency?.identifier ?? "USD")
    
    private let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson: Double {
        return totalAmount / Double(numberOfPeople)
    }
    
    var totalAmount: Double {
        // calculate the total with the tip included
        let tipSelection = Double(tipPercentage)
        let tipValue = ((checkAmount ?? 0.0) / 100) * tipSelection
        
        return (checkAmount ?? 0.0) + tipValue
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: currencyType)
                    .keyboardType(.decimalPad)
                    .focused($amountIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople, content: {
                        ForEach(2..<100, content: {
                            Text("\($0) people")
                        })
                    })
                } header: {
                    Text("Total amount")
                }
                
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0..<101, id: \.self) {
                            Text($0, format: .percent)                    .foregroundStyle(tipPercentage == 0 ? Color.red : Color.black)
                        }
                    }
                    .pickerStyle(.navigationLink)

                } header: {
                    Text("How much do you want to tip?")
                }
                
                Section {
                    Text(totalAmount, format: currencyType)
                } header: {
                    Text("Total amount with tip")
                }
                
                Section {
                    Text(totalPerPerson, format: currencyType)
                } header: {
                    Text("Amount per person")
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
