import Foundation
import NetworkClient

enum API: URLGenerator {
    case posts
    var method: HTTPMethod { return .get }
    
    var url: URL? {
        let url = URLComponents(string: "https://jsonplaceholder.typicode.com/posts")
        return url?.url
    }
}

