//
//  ModifierExample.swift
//  StateTransitionsAndAnimations
//
//  Created by Steven Curtis on 10/07/2024.
//

import SwiftUI

struct ModifierExample: View {
    @State private var isExpanded = false

    var body: some View {
        VStack {
            // Animated view that changes based on isExpanded state
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.blue)
                .frame(width: isExpanded ? 300 : 100, height: isExpanded ? 300 : 100)
                .animation(.easeInOut, value: isExpanded)
            
            Button(action: {
                self.isExpanded.toggle()
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
        ModifierExample()
}
