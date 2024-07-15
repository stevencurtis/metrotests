//
//  AnimatableExample.swift
//  StateTransitionsAndAnimations
//
//  Created by Steven Curtis on 10/07/2024.
//

import SwiftUI

struct Point: Animatable {
  var x: CGFloat
  var y: CGFloat

  var animatableData: AnimatablePair<CGFloat, CGFloat> {
    get { return AnimatablePair(x, y) }
    set {
      x = newValue.first
      y = newValue.second
    }
  }

  init(x: CGFloat, y: CGFloat) {
    self.x = x
    self.y = y
  }
}

struct AnimatableExample: View {
  @State private var position = CGPoint(x: 100, y: 100)

  var body: some View {
    Circle()
      .foregroundColor(.red)
      .frame(width: 50, height: 50)
      .position(position)
      .animation(.easeInOut(duration: 1), value: position)
      .gesture(
        DragGesture()
          .onChanged { value in
            position = value.location
          }
      )
  }
}

#Preview {
    AnimatableExample()
}
