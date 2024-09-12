import SwiftUI

import NetworkClient
import Combine
enum ViewState {
    case loading
    case success
    case error(APIError)
    case idle
}


@Observable
final class ViewModel {
    var posts: [Post] = []
    let service: PostsServiceProtocol
    var viewState: ViewState = .idle

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
            }
        }
    }
}

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
                    .alert(error.localizedDescription, isPresented: .constant(true), presenting: error) { details in
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


//struct ContentView: View {
//    @Bindable var viewModel: ViewModel
//
//    var body: some View {
//        Group {
//            switch viewModel.viewState {
//            case .loading:
//                ProgressView("Loading...")
//            case .success:
//                PostsView(posts: viewModel.posts)
//            case .idle:
//                Text("No content loaded yet")
//            case .error(let error):
//                PostsView(posts: viewModel.posts)
//                .alert(isPresented: .constant(true)) {
//                    Alert(
//                        title: Text(error.localizedDescription),
//                        message: Text(error.localizedDescription),
//                        primaryButton: .default(Text("Retry")) {
//                            viewModel.fetchPosts()
//                        },
//                        secondaryButton: .cancel(Text("Dismiss"))
//                    )
//                }
//            }
//        }
//        .onAppear(perform: viewModel.fetchPosts)
//        .padding()
//    }
//    
//    struct PostsView: View {
//        var posts: [Post]
//        var body: some View {
//            ScrollView {
//                ForEach(posts) { post in
//                    Text(post.title)
//                }
//            }
//        }
//    }
//}





//struct ContentView: View {
//    @Bindable var  viewModel: ViewModel
//
//    var body: some View {
//        ScrollView {
//            ForEach(viewModel.posts) { post in
//                Text(post.title)
//            }
//        }
//        
//        .alert(viewModel.peopleError?.title ?? "", isPresented: Binding(get: { viewModel.peopleError != nil }, set: { _ in }), presenting: viewModel.peopleError) { error in
//            Button("Retry") {
//                viewModel.peopleError = nil
//                viewModel.fetchPosts()
//            }
//            Button("Dismiss", role: .cancel) {}
//        } message: { error in
//            Text(error.title)
//        }
//        .onAppear(perform: viewModel.fetchPosts)
//        .padding()
//    }
//}
//
//
//#Preview {
//    ContentView(viewModel: ViewModel())
//}
//
//struct PeopleError {
//    let title: String
//}
//
//import NetworkClient
//import Observation
//import Combine
//
//@Observable
//final class ViewModel {
//    var posts: [Post] = []
//    let service: PostsServiceProtocol
//    var peopleError: PeopleError? = nil
//
//    private var fetchSubject = PassthroughSubject<Void, Never>()
//    private var cancellables = [AnyCancellable]()
//    init(service: PostsServiceProtocol = PostsService()) {
//        self.service = service
//
//        fetchSubject
//            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
//            .sink { [weak self] in
//                    self?.performFetch()
//            }
//            .store(in: &cancellables)
//    }
//
//    func fetchPosts() {
//        fetchSubject.send(())
//    }
//
//
//    private func performFetch() {
//        Task { @MainActor in
//            do {
//                posts = try await service.fetchPosts().map{ $0.toDomain() }
//                peopleError = nil
//            } catch {
//                peopleError = PeopleError(title: error.localizedDescription)
//            }
//        }
//    }
//}





//struct ContentView: View {
//    @ObservedObject var viewModel: ViewModel
//
//    var body: some View {
//        ScrollView {
//            Text("Will be a ForEach loop")
//        }
//        .alert("Error", isPresented: Binding<Bool>(
//            get: { (viewModel.peopleError != nil) == true },
//            set: { if !$0 {  } }
//        )) {
//            Button("Retry") {
//                viewModel.fetchPosts()
//            }
//            Button("Dismiss", role: .cancel) { }
//        } message: {
//            Text(viewModel.peopleError?.localizedDescription ?? "")
//        }
//        .onAppear {
//            viewModel.fetchPosts()
//        }
//        .padding()
//    }
//}
//
//final class ViewModel: ObservableObject {
//    @Published var peopleError: APIError? = nil
//
//    func fetchPosts() {
//        do {
////            throw APIError.generalToken
//        } catch {
//            peopleError = error as? APIError
//        }
//    }
//}


//struct ContentView: View {
//    @ObservedObject var viewModel: ViewModel
//
//    var body: some View {
//        ScrollView {
//            Text("Will be a ForEach loop")
//        }
//        .alert("Error", isPresented: $viewModel.showError, presenting: viewModel.peopleError) { error in
//            Button("Retry") {
//                viewModel.peopleError = nil
//                viewModel.fetchPosts()
//            }
//            Button("Dismiss", role: .cancel) { }
//        } message: { error in
//            Text(error.localizedDescription)
//        }
//        .onAppear(perform: viewModel.fetchPosts)
//        .padding()
//    }
//}
//
//final class ViewModel: ObservableObject {
//    @Published var peopleError: APIError? = nil
//    @Published var showError: Bool = false
//
//    func fetchPosts() {
//            do {
//                throw APIError.generalToken
//            } catch {
//                peopleError = error as? APIError
//                showError = true
//            }
//    }
//}





//struct ContentView: View {
//    @Bindable var  viewModel: ViewModel
//
//    var body: some View {
//        ScrollView {
//            ForEach(viewModel.posts) { post in
//                Text(post.title)
//            }
//        }
//        
//        .alert(viewModel.peopleError?.localizedDescription ?? "", isPresented: Binding(get: { viewModel.peopleError != nil }, set: { _ in }), presenting: viewModel.peopleError) { error in
//            Button("Retry") {
//                viewModel.peopleError = nil
//                viewModel.fetchPosts()
//            }
//            Button("Dismiss", role: .cancel) {}
//        } message: { error in
//            Text(error.localizedDescription)
//        }
//        .onAppear(perform: viewModel.fetchPosts)
//        .padding()
//    }
//}
//
//
//#Preview {
//    ContentView(viewModel: ViewModel())
//}
//
//import NetworkClient
//import Observation
//import Combine
//
//@Observable
//final class ViewModel {
//    var posts: [Post] = []
//    let service: PostsServiceProtocol
//    var peopleError: APIError? = nil
//
//    private var fetchSubject = PassthroughSubject<Void, Never>()
//    private var cancellables = [AnyCancellable]()
//    init(service: PostsServiceProtocol = PostsService()) {
//        self.service = service
//
//        fetchSubject
//            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
//            .sink { [weak self] in
//                    self?.performFetch()
//            }
//            .store(in: &cancellables)
//    }
//
//    func fetchPosts() {
//        fetchSubject.send(())
//    }
//
//
//    private func performFetch() {
//        Task { @MainActor in
//            do {
//                posts = try await service.fetchPosts().map{ $0.toDomain() }
//                peopleError = nil
//            } catch {
//                peopleError = error as? APIError
//            }
//        }
//    }
//}







//struct ContentView: View {
//    @Bindable var  viewModel: ViewModel
//
//    var body: some View {
//        ScrollView {
//            ForEach(viewModel.posts) { post in
//                Text(post.title)
//            }
//        }
//        .alert("Error", isPresented: $viewModel.showError, presenting: viewModel.peopleError) { error in
//            Button("Retry") {
//                viewModel.peopleError = nil
//                viewModel.showError = false
//                viewModel.fetchPosts()
//            }
//            Button("Dismiss", role: .cancel) {}
//        } message: { error in
//            Text(error.localizedDescription)
//        }
//        .onAppear(perform: viewModel.fetchPosts)
//        .padding()
//    }
//}
//
//
//#Preview {
//    ContentView(viewModel: ViewModel())
//}
//
//import Observation
//import Combine
//
//@Observable
//final class ViewModel {
//    var posts: [Post] = []
//    let service: PostsServiceProtocol
//    var peopleError: APIError? = nil
//    var showError: Bool = false
//    private var fetchSubject = PassthroughSubject<Void, Never>()
//    private var cancellables = [AnyCancellable]()
//    init(service: PostsServiceProtocol = PostsService()) {
//        self.service = service
//        
//        fetchSubject
//            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
//            .sink { [weak self] in
//                    self?.performFetch()
//            }
//            .store(in: &cancellables)
//    }
//    
//    func fetchPosts() {
//        fetchSubject.send(())
//    }
//    
//    
//    private func performFetch() {
//        Task { @MainActor in
//            do {
//                posts = try await service.fetchPosts().map{ $0.toDomain() }
//                peopleError = nil // Reset the error after a successful fetch
//                showError = false
//            } catch {
//                peopleError = error as? APIError
//                showError = true
//            }
//        }
//    }
//}


// https://jsonplaceholder.typicode.com/posts
