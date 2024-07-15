//
//  AnyTransitionExample.swift
//  StateTransitionsAndAnimations
//
//  Created by Steven Curtis on 10/07/2024.
//

import SwiftUI

struct AnyTransitionExample: View {
    @State private var showDetails = false
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    showDetails.toggle()
                }
            }) {
                Text("Toggle Details")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            if showDetails {
                Text("Here are the details!")
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(10)
                    .transition(AnyTransition.customFadeSlide)
            }
        }
    }
}

// This extension makes the transition reusable and separates the transition logic from the view code.
extension AnyTransition {
    static var customFadeSlide: AnyTransition {
        AnyTransition.opacity
            .combined(with: .move(edge: .trailing))
    }
}

#Preview {
    AnyTransitionExample()
}
