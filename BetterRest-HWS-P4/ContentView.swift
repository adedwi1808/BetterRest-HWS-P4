//
//  ContentView.swift
//  BetterRest-HWS-P4
//
//  Created by Ade Dwi Prayitno on 12/10/22.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp: Date = Date.now
    @State private var sleepAmount: Double = 0.0
    @State private var coffeeAmount: Int = 1
    
    var body: some View {
        NavigationView {
            VStack {
                Text("When do you want to wake up ?")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desire amount of sleep")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 2...12, step: 0.25)
                    
                Text("Daily coffee intake")
                    .font(.headline)
                
                Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 2...20)
            }
            .padding()
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
        }
    }
    func calculateBedtime() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
