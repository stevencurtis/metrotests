//
//  ViewModelTests.swift
//  StarWarsAPITests
//
//  Created by Steven Curtis on 30/08/2024.
//

import Combine
import NetworkClient
@testable import StarWarsAPI
import XCTest

final class ViewModelTests: XCTestCase {
    func testFetchPeopleSuccess() {
        // Given
        let mockPerson = PersonDTO(name: "dave")
        let mockPeople = PeopleDTO(next: "", results: [mockPerson], count: 44)

        let mockNetworkClient = MockNetworkClient()
        mockNetworkClient.fetchResult = MockSuccess(result: mockPeople)
        let viewModel = ViewModel(networkClient: mockNetworkClient)
        let expectation = XCTestExpectation()
        
        // When
        withObservationTracking {
            _ = viewModel.people
        } onChange: {
            expectation.fulfill()
        }
        viewModel.fetchPeople()
        
        // Then
        wait(for: [expectation])
        XCTAssertEqual(viewModel.people.count, 1)
        XCTAssertEqual(viewModel.people[0].name, mockPerson.name)
    }
    
    func testFetchPeopleFailure() {
        // Given
        let mockFailure = PeopleError.invalidURL

        let mockNetworkClient = MockNetworkClient()
        mockNetworkClient.fetchResult = MockFailure(error: mockFailure)
        let viewModel = ViewModel(networkClient: mockNetworkClient)
        let expectation = XCTestExpectation()
        
        // When
        withObservationTracking {
            _ = viewModel.peopleError
        } onChange: {
            expectation.fulfill()
        }
        viewModel.fetchPeople()
        
        // Then
        print(viewModel.people)
        
        wait(for: [expectation])
        XCTAssertEqual(viewModel.peopleError, mockFailure)
    }
    
    func testIsLoadingState() {
        // Given
        let mockNetworkClient = MockNetworkClient()
        let mockPerson = PersonDTO(name: "dave")
        let mockPeople = PeopleDTO(next: "", results: [mockPerson], count: 44)
        mockNetworkClient.fetchResult = MockSuccess(result: mockPeople)
        let viewModel = ViewModel(networkClient: mockNetworkClient)
        let expectation = XCTestExpectation()

        // When
        withObservationTracking {
            _ = viewModel.isLoading
        } onChange: {
            expectation.fulfill()
        }
        viewModel.fetchPeople()

        wait(for: [expectation])
        // Then
        XCTAssertTrue(viewModel.isLoading)
    }
    
    func testDebounceLoadMorePeople() {
        // Given
        let mockNetworkClient = MockNetworkClient()
        let mockPerson = PersonDTO(name: "dave")
        let mockPeople = PeopleDTO(next: "", results: [mockPerson], count: 44)
        mockNetworkClient.fetchResult = MockSuccess(result: mockPeople)
        let viewModel = ViewModel(networkClient: mockNetworkClient)
        let expectation = XCTestExpectation()

        viewModel.fetchPeople()

        // When
        withObservationTracking {
            _ = viewModel.people
        } onChange: {
            expectation.fulfill()
        }
        
        viewModel.requestLoadMorePeople()
        wait(for: [expectation])

        // Then
        XCTAssertEqual(viewModel.people.count, 1)
    }
}

protocol MockResult {
    associatedtype DataType
    func getResult() throws -> DataType?
}

struct MockSuccess<T>: MockResult {
    var result: T
    func getResult() throws -> T? { result }
}

struct MockFailure: MockResult {
    var error: Error
    func getResult() throws -> Never? { throw error }
}


final class MockNetworkClient: NetworkClient {
    var fetchResult: (any MockResult)?
    private(set) var fetchResultCalled = false
    
    func fetch<T>(
        api: URLGenerator,
        request: T
    ) async throws -> T.ResponseDataType? where T: APIRequest {
        fetchResultCalled = true
        return try fetchResult?.getResult() as? T.ResponseDataType
    }
}


//final class MockPeopleListService: PeopleListServiceProtocol {
//    var mockPeopleDTO = PeopleDTO(next: "", results: [PersonDTO(name: "Test Person")], count: 5)
//    func getPeople() async throws -> PeopleDTO {
//        mockPeopleDTO
//    }
//}
