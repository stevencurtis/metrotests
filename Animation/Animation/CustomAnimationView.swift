//
//  CustomAnimationView.swift
//  Animation
//
//  Created by Steven Curtis on 10/07/2024.
//

import SwiftUI

struct CustomAnimationView: View {
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1.0

    var body: some View {
        VStack {
            Image(.rosa)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                .opacity(opacity)
                .onTapGesture {
                    withAnimation(Animation.easeInOut(duration: 2.0).repeatCount(1, autoreverses: true)) {
                        scale = 1.5
                        rotation = 360
                        opacity = 0.5
                    }
                }

            Button("Reset") {
                withAnimation {
                    scale = 1.0
                    rotation = 0
                    opacity = 1.0
                }
            }
        }
    }
}

#Preview {
    CustomAnimationView()
}
