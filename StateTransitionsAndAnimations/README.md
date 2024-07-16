# Mastering State Transitions and Animations in SwiftUI
## Slightly More Complex Animation

Animations should be FUN! We should be thinking about how to make movement a real feature in our apps. This means we should take a look at the [motion section of Apple's HCI guidelines](https://developer.apple.com/design/human-interface-guidelines/motion).

That said, this article delves into state-driven UI updates and how to integrate animation to enhance user experiences.

## Explicit Animation
Provide detailed control over animation parameters, such as duration, delay, and curve.


```swift
import SwiftUI

struct ContentView: View {
    @State private var isExpanded = false

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.blue)
                .frame(width: isExpanded ? 300 : 100, height: isExpanded ? 300 : 100)
                .animation(.easeInOut, value: isExpanded)
            
            Button(action: {
                withAnimation {
                    self.isExpanded.toggle()
                }
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
    ContentView()
}
```

## Implicit Animation
Automatically animate changes in view properties without specifying any details about how the animation should occur.

```swift
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
```

## Animating Bindings
```swift
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
```

## Built-In and Custom Animations
**Animating Custom Views**
SwiftUI can animate many built-in view modifiers, such as those adjusting scale or opacity. For custom animations, you can make your views conform to the Animatable protocol and specify the animatable values.

```swift
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
```

*Animatable Modifier*
`AnimatableModifier` provides a structured and reusable way to encapsulate complex animations.

This `AnimatableModifier` is a combination of `Animatable` and `ViewModifier`.

```swift
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
```

**Managing View Transitions**
When state changes involve adding or removing views from the view hierarchy, use transitions to define how views should appear or disappear. SwiftUI provides several built-in transitions through the `AnyTransition` type, such as `.slide` and `.scale`. You can also create custom transitions.

In this example the `@State` property wrapper is used to manage view state, and the `.slide` transition provides a built-in smooth sliding animation. 

```swift
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
```

**AnyTransition**

AnyTransition is useful for managing the transitions between view states.

In the example below the transition is reusable. Transitions can also developed in this way to be flexible and possibly more complex.

```swift
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
```

## Conforming to Animatable
When the data you wish to animate is not inherently animatable you can conform to the `Animatable` protocol. This allows SwiftUI to understand how to interpolate between different states of data for animations.

The idea of using `Animatable` is that we can have
 - Smooth animations
 - Great control over animation behaviours
 - We can integrate with standard animation modifiers like `.animation(_:value:)`
 - Reusable code
 
 
 The code below allows dragging a dot around the screen, and essentially we are dragging a point around the screen that conforms to the `Animatable` protocol.

```swift
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
```

## Conforming to AnimatableModifier
`AnimatableModifier` creates reusable, custom animations that can be applied as view modifiers. This enables encapsulating animation logic within a modifier rather than in a view's structure.

Here are the advantages of using `AnimatableModifier`:
- Encapsulation of animation logic
- Reusability
- Customizable animations
- Integration with the animation system
- Dynamic triggering can trigger animations based on state changes or user interactions

This example allows the text to shake dynamically when tapped, for example to draw attention to an error. By binding the shakes parameter to a state variable, the animation can be controlled programmatically.

```swift
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
```

## Conclusion

Animation in SwiftUI? I've taken you on a little bit of an adventure in this article. I hope it has to some extent helped you out, and It's been in some way enjoyable.
