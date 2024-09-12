import NetworkClient

protocol PostsServiceProtocol {
    func fetchPosts() async throws -> [PostDTO]
}

final class PostsService: PostsServiceProtocol {
    let networkClient : NetworkClient
    
    init(networkClient: NetworkClient = MainNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchPosts() async throws -> [PostDTO] {
        let request = PostRequest()
        let response = try await networkClient.fetch(api: API.posts, request: request)
        return response ?? []
    }
}
