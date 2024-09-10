import Foundation
import NetworkClient

enum API: URLGenerator {
    case people(page: String)
    var method: HTTPMethod {
        .get
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
    }}
