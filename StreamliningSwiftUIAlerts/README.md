# Streamlining SwiftUI Alerts
## Why Separating Actions and Messages Improves Code Clarity

While happily coding, I noticed that `alert(item:content:)` is marked for deprecation.

That means I need to look at alternatives and think how to improve my code. It turns out my understanding of Alert left a little to be desired, and I could take some actions to make my SwiftUI code a little better.

My use case for alerts is to use them with dynamic content.

# Simple Boolean Alert
## alert(isPresented:content:)
`alert(isPresented:content:)` combined the alert's actions and message into one closure. This is usually used when presenting static alerts triggered by a simple boolean, so can I use this for my more complex use case?

Her is the basic example, and 

```swift
import SwiftUI

struct SimpleAlertView: View {
    @State private var showAlert = false

    var body: some View {
        Button("Show Alert") {
            showAlert = true
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Delete File"),
                message: Text("Are you sure you want to delete this file? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    // Delete action
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
    }
}

#Preview {
    SimpleAlertView()
}
```

This has the `showAlert` property in the view. This is fine, since the alert is a UI-only interaction.


So you might want to put this state into a view model if you are using an API. For this I've used my own [NetworkClient](https://github.com/stevencurtis/NetworkClient) and call a service from the view model.


So how does the view cope with an error where we want to use the `localizedDescription` for the title. It's *fine* but we would historically use `alert(item:content)` for this more complex content, as especially that `set` seems quite out of place and not a great piece of coding.

```swift
struct SimpleBooleanAPIView: View {
    var viewModel: SimpleBooleanAPIViewModel
    var body: some View {
        Group {
            List(viewModel.comments, rowContent: { comment in
                Text(comment.title)
                    .onTapGesture {
                        print("tapped \(comment)")
                    }
            })
        }
        .alert(
            viewModel.peopleError?.localizedDescription ?? "Default alert",
            isPresented: Binding(
                get: { viewModel.peopleError != nil },
                set: {_,_ in }
            ),
            actions: {})
        .onAppear(perform: viewModel.fetchPosts)
    }
}

@Observable
final class SimpleBooleanAPIViewModel {
    var comments: [Post] = []
    var peopleError: APIError? = nil
    private let service: PostsServiceProtocol

    init(service: PostsServiceProtocol = PostsService()) {
        self.service = service
    }
    
    func fetchPosts() {
        Task {
            do {
                comments = try await service.fetchPosts().map{ $0.toDomain() }
            } catch {
                peopleError = error as? APIError
            }
        }
    }
}
```
It's clear we need an alternative. That alternative used to be...

# The Old Way
## alert(item:content:)
You know what, I was happy with `alert(item:content:)`, but it was tied to presenting alerts based on optional values. Yet that was really why I liked it. Still, this is the old way and you can still use it as `alert(item:content:)` will only be deprecated in a future iOS version.

Here I've used the `Observation` framework, oh and I needed to create an `Identifiable` alert that is held in the view to be displayed as appropriate. 

```swift
struct PostAlert: Identifiable {
    let id = UUID()
    let alert: Alert
}

struct OldView: View {
    let viewModel: OldViewModel
    @State private var alert: PostAlert? = nil

    var body: some View {
        ScrollView {
            ForEach(viewModel.posts) { post in
                Text(post.title)
            }
        }
        .alert(item: $alert) { postAlert in
            postAlert.alert
        }
        .onAppear {
            viewModel.fetchPosts()
        }
        .onChange(of: viewModel.peopleError) { _, newError in
            if let newError = newError {
                alert = PostAlert(
                    alert: Alert(
                        title: Text(newError.localizedDescription),
                        dismissButton: .default(
                            Text("Dismiss"),
                            action: {
                                viewModel.peopleError = nil
                                viewModel.fetchPosts()
                            }
                        )
                    )
                )
            }
        }
        .padding()
    }
}

@Observable
final class OldViewModel {
    var posts: [Post] = []
    let service: PostsServiceProtocol
    var peopleError: APIError? = nil
    var showError: Bool = false
    init(service: PostsServiceProtocol = PostsService()) {
        self.service = service
    }

    func fetchPosts() {
        Task { @MainActor in
            do {
                posts = try await service.fetchPosts().map{ $0.toDomain() }
            } catch {
                peopleError = error as? APIError
                showError = true
            }
        }
    }
}

```


# After Deprecation
## alert(title:isPresented:presenting:actions:)
Passing an `Error` object allows `alert(title:isPresented:presenting:actions:)` for improved separation of concerns and readability. `isPresented` explicitly manages the presentation of the alert, making the code clearer and easier to follow. By tying the alert presentation directly to a Boolean (isPresented) and to a specific type (presenting), the flow of state and data through the view hierarchy becomes clearer.

The problem is how might we combine isPresented and the error as I wish to use this much as `alert(item:content:)`.

My answer is to use a view state in the view model. I've also implemented debounce here

```swift
struct ContentView: View {
    @Bindable var viewModel: ViewModel

    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                ProgressView("Loading...")
            case .success:
                PostsView(posts: viewModel.posts)
            case .idle:
                Text("No content loaded yet")
            case .error(let error):
                PostsView(posts: viewModel.posts)
                    .alert(error.localizedDescription, isPresented: $viewModel.showingAlert, presenting: error) { details in
                        Button("Retry") {
                            viewModel.fetchPosts()
                        }
                        Button("Dismiss", role: .cancel) {}
                    }
            }
        }
        .onAppear(perform: viewModel.fetchPosts)
        .padding()
    }

    struct PostsView: View {
        var posts: [Post]
        var body: some View {
            ScrollView {
                ForEach(posts) { post in
                    Text(post.title)
                }
            }
        }
    }
}

@Observable
final class ViewModel {
    enum ViewState {
        case loading
        case success
        case error(APIError)
        case idle
    }
    
    var posts: [Post] = []
    let service: PostsServiceProtocol
    var viewState: ViewState = .idle
    var showingAlert: Bool = false
    
    private var fetchSubject = PassthroughSubject<Void, Never>()
    private var cancellables = [AnyCancellable]()

    init(service: PostsServiceProtocol = PostsService()) {
        self.service = service
        fetchSubject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.performFetch()
            }
            .store(in: &cancellables)
    }

    func fetchPosts() {
        viewState = .loading
        fetchSubject.send(())
    }

    private func performFetch() {
        Task { @MainActor in
            do {
                posts = try await service.fetchPosts().map { $0.toDomain() }
                viewState = .success
            } catch {
                if let error = error as? APIError {
                    viewState = .error(error)
                } else {
                    viewState = .error(APIError.unknown)
                }
                 showingAlert = true
            }
        }
    }
}
```

# Conclusion
Transitioning from alert(item:content:) to the newer alert(title:isPresented:presenting:actions:) in SwiftUI presents an opportunity to enhance both code clarity and separation of concerns. By decoupling dynamic alert data from the UI and handling it within view models, we can write more modular, maintainable, and testable code. Though the deprecated approach may feel familiar, embracing the new patterns not only future-proofs your projects but also encourages better architecture. With SwiftUI evolving, leveraging these improvements ensures that your applications remain efficient, readable, and robust.
