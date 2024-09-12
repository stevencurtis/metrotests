import SwiftUI

struct PostAlert: Identifiable {
    let id = UUID()
    let alert: Alert
}

struct AlertOldModifier: ViewModifier {
    @Binding var postAlert: PostAlert?

    func body(content: Content) -> some View {
        content
            .alert(item: $postAlert) { postAlert in
                postAlert.alert
            }
    }
}

extension View {
    func alert(using postAlert: Binding<PostAlert?>) -> some View {
        self.modifier(AlertOldModifier(postAlert: postAlert))
    }
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
        .alert(using: $alert)

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
