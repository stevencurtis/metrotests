//
//  ViewTransition.swift
//  StateTransitionsAndAnimations
//
//  Created by Steven Curtis on 10/07/2024.
//

import SwiftUI

struct ViewTransition: View {
    @State private var showDetail = false

    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    showDetail.toggle()
                }
            }) {
                Text("Toggle Detail View")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            if showDetail {
                DetailView()
                    .transition(.slide)
            }
        }
        .padding()
    }
}

struct DetailView: View {
    var body: some View {
        VStack {
            Text("Detail View")
                .font(.largeTitle)
                .padding()
            
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.orange)
                .frame(width: 200, height: 200)
                .transition(AnyTransition.opacity.combined(with: .scale))
        }
        .padding()
        .background(Color.yellow)
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ViewTransition()
    }
}
