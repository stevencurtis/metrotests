//
//  Shake.swift
//  StateTransitionsAndAnimations
//
//  Created by Steven Curtis on 10/07/2024.
//

import SwiftUI

struct ShakeEffect: AnimatableModifier {
    var shakes: CGFloat = 0
    
    var animatableData: CGFloat {
        get { shakes }
        set { shakes = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: sin(shakes * 2 * .pi) * 10)
    }
}

extension Animation {
    static var shake: Animation {
        Animation.easeInOut(duration: 0.5)
            .repeatCount(3)
    }
}

struct ShakeExample: View {
    @State private var isShaking = false
    
    var body: some View {
        Text("Shake Me!")
            .modifier(ShakeEffect(shakes: isShaking ? 1 : 0))
            .onTapGesture {
                withAnimation(.shake) {
                    isShaking.toggle()
                }
            }
    }
}

#Preview {
    ShakeExample()
}
