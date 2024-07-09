# An Introduction to SwiftUI Animations
##

# Animations
**Implicit Animations** 
Automatically animate changes in view properties without specifying any details about how the animation should occur.
**Explicit Animations** 
Provide detailed control over animation parameters, such as duration, delay, and curve.
**Custom Animations** 
Combine different animation effects and control the sequence of animated changes.

# Implicit animations
Animations can be added in SwiftUI through implicit animations.

This type of animation is trivial to implement

The animation will trigger implicitly whenever animationAmount changes, regardless of where that change is made in the code. This approach is more declarative and requires less code to set up animations in response to state changes.

the animation is implicit in the sense that it’s not tied directly within an action block or condition that triggers the animation. Instead, any change to the scale property automatically triggers the animation specified by the .animation() modifier, without further specifications on when to start or stop the animation, making it implicit.

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

We could simply add the animation to an enclosing VStack, but this will quickly become unwieldy.


# Explicit animations
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



Note: withAnimation() isn’t a view modifier like .animation(). It’s a function that needs to be called to perform the change to the state smoothly. This means that any view that uses the same state in its view will also be animated.


# Custom animations




Animation Modifiers

Modifiers such as .scaleEffect() and .rotationEffect() can be used to adjust how elements transform during animations. They are essential for creating visually appealing effects.
