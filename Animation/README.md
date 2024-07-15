# An Introduction to SwiftUI Animations
## Implicit and Explicit animations

[images/ImplicitExplicitAnimations.png](images/ImplicitExplicitAnimations.png)<br>

## Animations
**Implicit Animations** 
Automatically animate changes in view properties without specifying any details about how the animation should occur.
**Explicit Animations** 
Provide detailed control over animation parameters, such as duration, delay, and curve.
**Custom Animations** 
Combine different animation effects and control the sequence of animated changes.

## Implicit animations
Animations can be added in SwiftUI through implicit animations.

This type of animation is trivial to implement, and behave basically how you might expect.

The animation will trigger implicitly whenever animationAmount changes, regardless of where that change is made in the code. This approach is more declarative and requires less code to set up animations in response to state changes.

the animation is implicit in the sense that it’s not tied directly within an action block or condition that triggers the animation. Instead, any change to the scale property automatically triggers the animation specified by the `.animation()` modifier, without further specifications on when to start or stop the animation, making it implicit.

The implicit animation takes place on all the properties of the view which change.

```swift
Image(.rosa)
    .resizable()
    .scaledToFit()
    .frame(width: 100 * scale, height: 100 * scale)
    .onTapGesture {
        scale += 0.5
    }
    .animation(.default, value: scale)
```

The movement of the text below is not smooth because SwiftUI will only add the animation to the view were the implicit animation happens.

We could simply add the animation to an enclosing `VStack`, but this will quickly become unwieldy.

## Explicit animations
Explicit animations dispatch the transaction from the root view.

Explicit animations are controlled explicitly by the developer. 

```swift
Image(.rosa)
    .resizable()
    .scaledToFit()
    .frame(width: 100 * scale, height: 100 * scale)
    .onTapGesture {
        withAnimation {
            scale += 0.5
        }
    }
```
Therefore these animations are generally more suited to animations where you require control over timing, conditions or sequencing. If you want complex animations that coordinate based on state changes these are the type of animations you should be using. 


Note: withAnimation() isn’t a view modifier like `.animation()`. It’s a function that needs to be called to perform the change to the state smoothly. This means that any view that uses the same state in its view will also be animated.

## Custom animations

Custom animations allow you to create more sophisticated animations by defining custom animation curves, sequences, or combining multiple effects.

```swift
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
```

## Animation Modifiers

Animation modifiers in SwiftUI allow you to transform and animate views. They create visually appealing and dynamic effects. Here are some commonly used animation modifiers and how you can use them in your SwiftUI projects:

**Scale Effect**
The `.scaleEffect()` modifier scales a view by a specified factor. It is often used to make views appear to grow or shrink.
```swift
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
```

**Rotation Effect**
The `.rotationEffect()` modifier rotates a view by a specified number of degrees. This can be useful for creating spinning or rotating animations.
```swift
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
```
**Opacity**
The `.opacity()` modifier changes the transparency of a view. It is useful for creating fade-in or fade-out effects.
```swift
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
```

**Offset**
The `.offset()` modifier moves a view by a specified amount in the x and y directions. It can be used to create sliding or moving animations.
```swift
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
```

**Combine Modifiers**
You can combine multiple animation modifiers to create more complex animations. For example, you can scale, rotate, and change the opacity of a view simultaneously:

```swift
struct AnimationModifiers: View {
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
    AnimationModifiers()
}
```

## Conclusion

Animations in SwiftUI are quite cool. This is an introductory article to the matter, and I hope that you enjoyed reading it and perhaps understanding a little bit about this topic.
