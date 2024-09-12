import NetworkClient

protocol PeopleServiceProtocol {
    func fetchPeople(page: String) async throws -> PeopleDTO?
}

typealias PeopleRequest = BasicRequest<PeopleDTO>

final class PeopleService: PeopleServiceProtocol {
    let networkClient: NetworkClient
    init(networkClient: NetworkClient = MainNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchPeople(page: String) async throws -> PeopleDTO? {
        let request = PeopleRequest()
        let people = try await networkClient.fetch(api: API.people(page: page), request: request)
        return people
    }
}
