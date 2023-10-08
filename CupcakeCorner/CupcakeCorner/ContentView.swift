//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Alberto Peinado Santana on 20/8/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var order = Order()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Flavor", selection: $order.type) {
                        ForEach(Order.types.indices) { index in
                            Text(Order.types[index])
                        }
                    }
                    
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special requests?", isOn: $order.specialRequestEnabled.animation())
                    
                    Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        .disabled(!order.specialRequestEnabled)
                    
                    Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                        .disabled(!order.specialRequestEnabled)
                }
                
                Section {
                    NavigationLink {
                        AddressView(order: order)
                    } label: {
                        Text("Delivery details")
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
