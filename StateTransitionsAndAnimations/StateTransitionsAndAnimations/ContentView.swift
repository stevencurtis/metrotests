//
//  ContentView.swift
//  StateTransitionsAndAnimations
//
//  Created by Steven Curtis on 10/07/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isExpanded = false

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.blue)
                .frame(width: isExpanded ? 300 : 100, height: isExpanded ? 300 : 100)
                .animation(.easeInOut, value: isExpanded)
            
            Button(action: {
                withAnimation {
                    self.isExpanded.toggle()
                }
            }) {
                Text("Toggle Size")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
