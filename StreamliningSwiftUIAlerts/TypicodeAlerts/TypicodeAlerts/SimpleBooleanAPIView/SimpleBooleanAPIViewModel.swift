import NetworkClient
import Observation

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
