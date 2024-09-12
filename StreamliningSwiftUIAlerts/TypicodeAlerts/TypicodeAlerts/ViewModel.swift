import Combine
import Foundation
import NetworkClient
import Observation

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
