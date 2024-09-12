import Foundation

struct PostDTO: Decodable {
    let userId: Int
    let title: String
    
    func toDomain() -> Post {
        Post(title: title)
    }
}
