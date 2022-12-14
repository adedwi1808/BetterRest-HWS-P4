//
//  ContentView.swift
//  BetterRest-HWS-P4
//
//  Created by Ade Dwi Prayitno on 12/10/22.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp: Date = defaultWaketime
    @State private var sleepAmount: Double = 0.0
    @State private var coffeeAmount: Int = 1
    
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showingAlert: Bool = false
    
    static var defaultWaketime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                    
                } header: {
                    Text("When do you want to wake up ?")
                        .font(.headline)
                }
                
                Section {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 2...12, step: 0.25)
                } header: {
                    Text("Desire amount of sleep")
                        .font(.headline)
                }
                
                Section {
//                    Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                    Picker(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", selection: $coffeeAmount) {
                        ForEach(1...20, id: \.self) {
                            Text($0, format: .number)
                        }
                    }
                } header: {
                    Text("Daily coffee intake")
                        .font(.headline)
                }
                
                Section {
                    Text(alertMessage)
                } header: {
                    Text(alertTitle)
                        .font(.headline)
                }
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
//            .alert(alertTitle, isPresented: $showingAlert) {
//                Button("Ok"){}
//            } message: {
//                Text(alertMessage)
//            }
        }.onAppear() {
            calculateBedtime()
        }
    }
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Err"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
