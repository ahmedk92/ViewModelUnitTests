//
//  ViewModelUnitTestsTests.swift
//  ViewModelUnitTestsTests
//
//  Created by Ahmed Khalaf on 27/01/2023.
//

import XCTest
@testable import ViewModelUnitTests

final class ViewModelUnitTestsTests: XCTestCase {
    
    private var viewModel: ViewModel!
    private var mockAsyncRunner: MockAsyncRunner!

    override func setUpWithError() throws {
        mockAsyncRunner = .init()
        viewModel = .init(asyncRunner: mockAsyncRunner)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockAsyncRunner = nil
    }

    func testExample() async throws {
        // Given
        let givenEmail = "ahmed@example.com"
        let expectedMessage = "Did receive ahmed@example.com"
        
        // When
        viewModel.email = givenEmail
        let actualMessage = viewModel.message
        
        // Then
        try await mockAsyncRunner.await()
        XCTAssertEqual(expectedMessage, actualMessage)
        XCTAssertTrue(viewModel.didLog)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class MockAsyncRunner: AsyncRunner {
    private var asyncBlocks: [AsyncBlock] = []
    
    func runAsync(block: @escaping AsyncBlock) {
        asyncBlocks.append(block)
    }
    
    func await() async throws {
        for asyncBlock in asyncBlocks {
            try await asyncBlock()
        }
        
        asyncBlocks.removeAll()
    }
}
