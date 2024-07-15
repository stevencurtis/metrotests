//
//  BinderAnimation.swift
//  StateTransitionsAndAnimations
//
//  Created by Steven Curtis on 10/07/2024.
//

import SwiftUI

struct BinderAnimation: View {
    @State private var sliderValue: CGFloat = 0.5

    var body: some View {
        VStack {
            Circle()
                .fill(Color.blue)
                .frame(width: sliderValue * 200, height: sliderValue * 200)
                .animation(.easeInOut, value: sliderValue)

            Slider(value: $sliderValue.animation(.easeInOut), in: 0...1)
                .padding()
        }
        .padding()
    }
}

#Preview {
    BinderAnimation()
}
