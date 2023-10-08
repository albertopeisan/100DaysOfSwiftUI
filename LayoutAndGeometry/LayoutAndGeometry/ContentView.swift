//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Alberto Peinado Santana on 25/9/23.
//

import SwiftUI

struct ContentView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]

    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                ForEach(0..<50) { index in
                    GeometryReader { geo in
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(colors[index % 7])
                            .rotation3DEffect(.degrees(geo.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
                            .opacity((1 / 500) * geo.frame(in: .global).minY)
                            .scaleEffect((1 / 500) * geo.frame(in: .global).minY)
                        
                        
                        
                        let _ = print((1 / 200) * geo.frame(in: .global).minY)
                    }
                    .frame(height: 40)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
