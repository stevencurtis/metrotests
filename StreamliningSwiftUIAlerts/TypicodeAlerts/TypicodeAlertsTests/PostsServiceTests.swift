@testable import TypicodeAlerts
import NetworkClientTestUtilities
import XCTest

final class PostsServiceTests: XCTestCase {
    func testFetchPosts() async throws {
        let mockPosts = [PostDTO(userId: 1, title: "title")]
        let mockNetworkClient = MockNetworkClient()
        mockNetworkClient.fetchResult = MockSuccess(result: mockPosts)
        let sut = PostsService(networkClient: mockNetworkClient)
        
        let posts = try await sut.fetchPosts()
        
        XCTAssertEqual(posts, mockPosts)
    }
}
