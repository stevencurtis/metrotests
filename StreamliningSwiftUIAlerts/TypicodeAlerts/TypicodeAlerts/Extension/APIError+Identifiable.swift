import Foundation
import NetworkClient

extension APIError: Identifiable {
    public var id: UUID { UUID() }
}

