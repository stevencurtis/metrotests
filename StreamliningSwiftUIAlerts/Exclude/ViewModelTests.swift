@testable import TypicodeAlerts
import NetworkClient
import NetworkClientTestUtilities
import XCTest

final class ViewModelTests: XCTestCase {
    func testFetchPostsSuccess() {
        let expectation = XCTestExpectation()
        let mockService = MockPostsService()
        let mockPostDTO = [PostDTO(userId: 1, title: "title")]
        mockService.fetchPostsResponse = .fetchPostsResponse(mockPostDTO)
        let sut = ViewModel(service: mockService)
        
        withObservationTracking(
            { _ = sut.posts },
            onChange: {
                expectation.fulfill()
            }
        )
        
        sut.fetchPosts()
        
        wait(for: [expectation])
        XCTAssertEqual(sut.posts, mockPostDTO.map{ $0.toDomain() })
    }
    
    func testFetchPostsFailure() {
        let expectation = XCTestExpectation()
        let mockService = MockPostsService()
        let mockError = APIError.generalToken
        mockService.fetchPostsResponse = .fetchPostsError(mockError)
        let sut = ViewModel(service: mockService)
        
        withObservationTracking(
            { _ = sut.peopleError },
            onChange: {
                expectation.fulfill()
            }
        )
        
        sut.fetchPosts()
        
        wait(for: [expectation])
        XCTAssertEqual(sut.peopleError, mockError)

    }
}

final class MockPostsService: PostsServiceProtocol {
    var fetchPostsResponse: FetchPostsResponse? = nil
    func fetchPosts() async throws -> [PostDTO] {
        guard let response = fetchPostsResponse else { return [] }
        switch response {
        case .fetchPostsError(let APIError):
            throw APIError
        case .fetchPostsResponse(let array):
            return array
        }
    }
    
    enum FetchPostsResponse {
        case fetchPostsError(APIError)
        case fetchPostsResponse([PostDTO])
    }
}
