import SwiftUI


struct PeopleAlert: Identifiable {
    let id = UUID()
    let alert: Alert
}

struct AlertModifier: ViewModifier {
    @Binding var peopleAlert: PeopleAlert?

    func body(content: Content) -> some View {
        content
            .alert(item: $peopleAlert) { peopleAlert in
                peopleAlert.alert
            }
    }
}

extension View {
    func alert(using peopleAlert: Binding<PeopleAlert?>) -> some View {
        self.modifier(AlertModifier(peopleAlert: peopleAlert))
    }
}

import SwiftUI

struct PeopleView: View {
    let viewModel: ViewModel = ViewModel()
    @State private var identifiableAlert: PeopleAlert? = nil
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.people.indices, id: \.self) { index in
                            Text(viewModel.people[index].name)
                                .onAppear {
                                    if index == viewModel.people.count - 1 && !viewModel.isLoading {
                                        viewModel.requestLoadMorePeople()
                                    }
                                }
                        }
                    }
                }
            }
        }
        .padding()
        .alert(using: $identifiableAlert)
        .onChange(of: viewModel.peopleError) { _, newError in
            if let newError = newError {
                identifiableAlert = PeopleAlert(alert: Alert(title: Text(newError.localizedDescription)))
            }
        }
        .onAppear {
            viewModel.fetchPeople()
        }
    }
}

#Preview {
    PeopleView()
}


//struct PeopleView: View {
//    let viewModel: ViewModel = ViewModel()
//    @State private var alert: Alert? = nil
//    var body: some View {
//        Group {
//            if viewModel.isLoading {
//                ProgressView()
//            } else {
//                ScrollView {
//                    VStack {
//                        ForEach(viewModel.people.indices, id: \.self) { index in
//                            Text(viewModel.people[index].name)
//                                .onAppear {
//                                    if index == viewModel.people.count - 1 {
//                                        viewModel.requestLoadMorePeople()
//                                    }
//                                }
//                        }
//                    }
//                }
//            }
//        }
//        .padding()
//        .alert(isPresented: Binding(get: { alert != nil }, set: { _ in })) {
//            guard let alert = alert else { return Alert(title: Text("default")) }
//            return alert
//        }
//        .onChange(of: viewModel.peopleError) { _ , newError in
//            alert = Alert(title: Text(newError?.localizedDescription ?? "default"))
//        }
//        .onChange(of: viewModel.people) { _ , newPerson in
//            print(newPerson)
//        }
//        .onAppear {
//            viewModel.fetchPeople()
//        }
//    }
//}

#Preview {
    PeopleView()
}

import Observation
import NetworkClient


import SwiftUI
import Combine

@Observable
final class ViewModel: ObservableObject {
    private(set) var people: [Person] = []
    private(set) var isLoading: Bool = false
    private(set) var peopleError: PeopleError? = nil
    
    private var totalPeople = 0
    private var currentPage = 1
    private var cancellables = Set<AnyCancellable>()
    
    private let networkClient: NetworkClient
    private let loadMoreSubject = PassthroughSubject<Void, Never>()
    
    init(networkClient: NetworkClient = MainNetworkClient()) {
        self.networkClient = networkClient
        setupDebounce()
    }
    
    func fetchPeople() {
        guard !isLoading else { return }
        isLoading = true
        
        Task { @MainActor in
            defer { isLoading = false }
            do {
                try await loadPeople()
            } catch {
                peopleError = error as? PeopleError
            }
        }
    }
    
    func requestLoadMorePeople() {
        loadMoreSubject.send()
    }
    
    private func loadMorePeople() {
        guard people.count < totalPeople else { return }
        
        Task { @MainActor in
            do {
                try await loadPeople()
            } catch {
                peopleError = error as? PeopleError
            }
        }
    }
    
    @MainActor
    private func loadPeople() async throws {
        let request = PeopleRequest()
        if let peopleDTO: PeopleDTO = try await networkClient.fetch(api: API.people(page: "\(currentPage)"), request: request) {
                totalPeople = peopleDTO.count
                people.append(contentsOf: peopleDTO.results.map { Person(personDTO: $0) })
                currentPage += 1
        } else {
            throw PeopleError.nilResponse
        }
    }
    
    private func setupDebounce() {
        loadMoreSubject
            .debounce(for: .seconds(0.25), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadMorePeople()
            }
            .store(in: &cancellables)
    }
}

typealias PeopleRequest = BasicRequest<PeopleDTO>


enum PeopleError: Error, LocalizedError {
    case decodingError
    case generalError
    case invalidURL
    case nilResponse
    
    public var errorDescription: String? {
        switch self {
        case .decodingError:
            "decodingError"
        case .generalError:
            "generalError"
        case .invalidURL:
            "invalidURL"
        case .nilResponse:
            "nilResponse"
        }
    }
}

struct Person: Identifiable, Equatable {
    let id: UUID = UUID()
    let name: String
    
    init(personDTO: PersonDTO) {
        name = personDTO.name
    }
}

struct PersonDTO: Decodable {
    let name: String
}

struct PeopleDTO: Decodable {
    let next: String?
    let results: [PersonDTO]
    let count: Int
}

enum API: URLGenerator {
    case people(page: String)

    var method: HTTPMethod {
        return .get
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "swapi.dev"
        components.path = "/api/people/"
        components.queryItems = makeQueryItems(page: "1")
        return components.url
    }
    
    private func makeQueryItems(page: String) -> [URLQueryItem] {
        if case let .people(page) = self {
            return [URLQueryItem(name: "page", value: page)]
        } else {
            return []
        }
    }
}

//let urlString = "https://swapi.dev/api/people/?page=1"
