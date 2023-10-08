//
//  ContentView.swift
//  Challenge1
//
//  Created by Alberto Peinado Santana on 12/8/23.
//

import SwiftUI

struct ContentView: View {
    @State private var measurement: String = ""
    @State private var inputUnit: Int = 0
    @State private var outputUnit: Int = 0
    
    let unitOptions = [UnitLength.millimeters,
                       UnitLength.centimeters,
                       UnitLength.meters,
                       UnitLength.inches,
                       UnitLength.feet,
                       UnitLength.yards,
                       UnitLength.kilometers,
                       UnitLength.miles
    ]
    
    var conversionCalc: Measurement<UnitLength> {
        let inputAmount = Measurement(value: Double(measurement) ?? 0, unit: unitOptions[inputUnit])
        let outputAmount = inputAmount.converted(to: unitOptions[outputUnit])
        
        return outputAmount
    }
    
    var formatter: MeasurementFormatter {
        let newFormat = MeasurementFormatter()
        newFormat.unitStyle = .long
        newFormat.unitOptions = .providedUnit
        
        return newFormat
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Insert a distance", text: $measurement)
                        .keyboardType(.decimalPad)
                    
                    Picker("Input Unit", selection: $inputUnit) {
                        ForEach(0..<unitOptions.count, id: \.self) {
                            Text("\(formatter.string(from: unitOptions[$0]))")
                        }
                    }
                    
                    Picker("Output Unit", selection: $outputUnit) {
                        ForEach(0..<unitOptions.count, id: \.self) {
                            Text("\(formatter.string(from: unitOptions[$0]))")
                        }
                    }
                }
                
                Section {
                    Text("\(formatter.string(from: conversionCalc))")
                } header: {
                    Text("Unit conversion")
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
