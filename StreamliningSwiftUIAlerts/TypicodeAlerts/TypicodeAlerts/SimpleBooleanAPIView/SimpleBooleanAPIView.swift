import SwiftUI

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

#Preview {
    SimpleBooleanAPIView(viewModel: SimpleBooleanAPIViewModel())
}
