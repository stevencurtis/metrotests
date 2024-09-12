import SwiftUI

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

#Preview {
    OldView(viewModel: OldViewModel())
}
