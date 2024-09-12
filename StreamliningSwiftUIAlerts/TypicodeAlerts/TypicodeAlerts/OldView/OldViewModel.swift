import NetworkClient
import Observation

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
