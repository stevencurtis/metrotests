//
//  AnimationModifiers.swift
//  Animation
//
//  Created by Steven Curtis on 10/07/2024.
//

import SwiftUI

struct AnimationModifiers: View {
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1.0
    @State private var offsetX: CGFloat = 0
    @State private var offsetY: CGFloat = 0

    var body: some View {
        VStack {
            Text("Scale")
            Image(.rosa)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .scaleEffect(scale)
                .onTapGesture {
                    withAnimation {
                        scale += 0.5
                    }
                }
            Text("Rotation")
            Image(.rosa)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(rotation))
                .onTapGesture {
                    withAnimation {
                        rotation += 45
                    }
                }
            Text("Opacity")
            Image(.rosa)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .opacity(opacity)
                .onTapGesture {
                    withAnimation {
                        opacity = opacity == 1.0 ? 0.5 : 1.0
                    }
                }
            Text("Offset")
            Image(.rosa)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .offset(x: offsetX, y: offsetY)
                .onTapGesture {
                    withAnimation {
                        offsetX += 50
                        offsetY += 50
                    }
                }
        }
    }
}

#Preview {
    AnimationModifiers()
}


