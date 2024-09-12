import Combine
import Foundation
import Observation

@Observable
@MainActor
final class ViewModel {
    var people: [Person] = []
    var isLoading = true
    private let service: PeopleServiceProtocol
    private var page: Int = 1
    private var loadMoreSubject = PassthroughSubject<Void, Never>()
    private var fetchTaskQueue = TaskQueue()
    private var cancellables = [AnyCancellable]()
    init(service: PeopleServiceProtocol = PeopleService()) {
        self.service = service
        loadMoreSubject
            .debounce(for: .seconds(0.25), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.fetchPeople()
        })
        .store(in: &cancellables)
    }

    func fetchPeople() {
        Task {
            await fetchTaskQueue.addTask { [weak self] in
                guard let self else { return }
                if let people = try? await self.service.fetchPeople(page: "\(self.page)") {
                    self.people += people.results.map { $0.toDomain() }
                }
                self.isLoading = false
            }
        }
    }
    
    func fetchMorePeople() {
        page += 1
        loadMoreSubject.send()
    }
    
    func cancelTasks() {
        Task {
            await fetchTaskQueue.cancelTasks()
        }
    }
}
