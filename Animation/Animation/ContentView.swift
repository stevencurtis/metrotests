//
//  ContentView.swift
//  Animation
//
//  Created by Steven Curtis on 05/07/2024.
//

import SwiftUI

struct ContentView: View {
    @State var isExpanded = false
    
    @State private var explicitAnimationAmount = 1.0
    var body: some View {
        ScrollView {
            Text("Animations")
                .font(.largeTitle)
            
            VStack(spacing: 16) {
                Group {
                    ImplicitView()
                    Text("This is an Implicit Animation")
                    ExplicitView()
                    Text("This is an Explicit Animation")
                }
                .padding()
            }
        }
    }
}

private struct ImplicitView: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        Image(.rosa)
            .resizable()
            .scaledToFit()
            .frame(width: 100 * scale, height: 100 * scale)
            .onTapGesture {
                scale += 0.5
            }
            .animation(.default, value: scale)
    }
}

private struct ExplicitView: View {
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Image(.rosa)
            .resizable()
            .scaledToFit()
            .frame(width: 100 * scale, height: 100 * scale)
            .onTapGesture {
                withAnimation {
                    scale += 0.5
                }
            }
    }
}

#Preview {
    ContentView()
}
