//
//  AnimationModifiers.swift
//  Animation
//
//  Created by Steven Curtis on 10/07/2024.
//

import SwiftUI

struct AnimationModifiersCombined: View {
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1.0
    @State private var offsetX: CGFloat = 0
    @State private var offsetY: CGFloat = 0

    var body: some View {
        VStack {
            Image(.rosa)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                .opacity(opacity)
                .offset(x: offsetX, y: offsetY)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        scale += 0.5
                        rotation += 45
                        opacity = opacity == 1.0 ? 0.5 : 1.0
                        offsetX += 20
                        offsetY += 20
                    }
                }

            Button("Reset") {
                withAnimation {
                    scale = 1.0
                    rotation = 0
                    opacity = 1.0
                    offsetX = 0
                    offsetY = 0
                }
            }
        }
    }
}

#Preview {
    AnimationModifiersCombined()
}

