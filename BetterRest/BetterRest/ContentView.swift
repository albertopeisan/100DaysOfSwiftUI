//
//  ContentView.swift
//  BetterRest
//
//  Created by Alberto Peinado Santana on 14/8/23.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("\(getBedTime())")
                        .font(.headline)
                } header: {
                    Text("Current recommended bedtime")
                }
                
                VStack (alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents:  .hourAndMinute)
                        .labelsHidden()
                }
                
                VStack (alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted())", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                VStack (alignment: .leading, spacing: 0){
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20, step: 1)
                }
                
                VStack (alignment: .leading, spacing: 0){
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    // Challenge 2
                    Picker("Daily coffe intake", selection: $coffeeAmount) {
                        ForEach(1..<21, id: \.self) { number in
                            Text("\(number == 1 ? "1 cup" : "\(number) cups" )")
                        }
                    }
                }
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedTime)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // Challenge 3
    func getBedTime() -> String {
        do {
            let model = try SleepCalculator(configuration: MLModelConfiguration())
            
            let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
            let hour = components.hour ?? 0
            let minute = components.minute ?? 0
            let seconds = (hour * 3600) + (minute * 60)
            let prediction = try model.prediction(wake: Double(seconds), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {}
        
        return ""
    }
    
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
            
            let hour = components.hour ?? 0
            let minute = components.minute ?? 0
            let seconds = (hour * 3600) + (minute * 60)
            
            let prediction = try model.prediction(wake: Double(seconds), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
        
            
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            // Something went wrong
            alertTitle = "Error"
            alertMessage = "Whooooops! Something went wrong."
        }
        
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
