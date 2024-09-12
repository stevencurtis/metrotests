import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ScrollView {
            Text("Will be a ForEach loop")
        }
        .alert("Error", isPresented: Binding<Bool>(
            get: { viewModel.error != nil },
            set: { if !$0 {  } }
        )) {
            Button("Retry") {
                viewModel.throwError()
            }
            Button("Dismiss", role: .cancel) {
                viewModel.error = nil
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "Unknown error")
        }
        .onAppear {
            viewModel.throwError()
        }
        .padding()
    }
}

@MainActor
final class ViewModel: ObservableObject {
    @Published var error: MyError? = nil

    func throwError() {
        do {
            throw MyError.standard
        } catch {
            self.error = error as? MyError
        }
    }
}

enum MyError: Error, Identifiable {
    var id: UUID { UUID() }
    case standard
}

#Preview {
    ContentView(viewModel: ViewModel())
}
