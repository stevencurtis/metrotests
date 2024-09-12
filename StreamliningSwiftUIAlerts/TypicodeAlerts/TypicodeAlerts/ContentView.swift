import SwiftUI

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
