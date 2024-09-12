@testable import TypicodeAlerts

extension PostDTO: Equatable {
    static public func == (lhs: PostDTO, rhs: PostDTO) -> Bool {
        lhs.userId == rhs.userId
    }
}
