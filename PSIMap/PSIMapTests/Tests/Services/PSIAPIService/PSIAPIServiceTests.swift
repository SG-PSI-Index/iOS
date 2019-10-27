//
//  PSIAPIServiceTests.swift
//  PSIMapTests
//
//  Created by Kevin Lo on 27/10/2019.
//  Copyright © 2019 Zuhlke Engineering HK Limited. All rights reserved.
//

import XCTest
@testable import PSIMap

class PSIAPIServiceTests: XCTestCase {

    let subject: PSIAPIServiceProtocol = PSIAPIService()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        unregisterAPIMocks()
    }

}

// MARK: - Tests

extension PSIAPIServiceTests {

    func test_getPSI_withResponse_shouldReturnSuccessResult() {
        // Arrange
        let apiCompleteExpectation = expectation(description: "hasResult")
        registerSuccessAPIMocks()

        // Act
        var result: GetPSIResult? = nil
        subject.getPSI {
            result = $0
            apiCompleteExpectation.fulfill()
        }

        // Assert
        wait(for: [apiCompleteExpectation], timeout: 1.0)
        switch result {
        case .success(let response):
            XCTAssertFalse(response.items.isEmpty)
        case .failure:
            XCTFail("Should not return failure result")
        case nil:
            XCTFail("Fail to get any result")
        }
    }

    func test_getPSI_withError_shouldReturnFailureResult() {
        // Arrange
        let apiCompleteExpectation = expectation(description: "hasResult")
        registerErrorAPIMocks()

        // Act
        var result: GetPSIResult? = nil
        subject.getPSI {
            result = $0
            apiCompleteExpectation.fulfill()
        }

        // Assert
        wait(for: [apiCompleteExpectation], timeout: 1.0)
        switch result {
        case .success:
            XCTFail("Should not return success response")
        case .failure:
            // Test pass
            break
        case nil:
            XCTFail("Fail to get any result")
        }
    }

}

// MARK: - Helpers

extension PSIAPIServiceTests {

    private var mockData: Data {
        let bundle = Bundle(for: type(of: self))
        guard
            let mockDataURL = bundle.url(forResource: "psi-api-response", withExtension: "json"),
            let mockData = try? Data(contentsOf: mockDataURL)
            else
        {
            return Data()
        }
        return mockData
    }

    private func registerSuccessAPIMocks() {
        if let url = URL(string: "https://api.data.gov.sg/v1/environment/psi") {
            MockURLProtocol.registerMockResponse(at: url, status: 200, body: mockData)
        }
        URLProtocol.registerClass(MockURLProtocol.self)
    }

    private func registerErrorAPIMocks() {
        if let url = URL(string: "https://api.data.gov.sg/v1/environment/psi") {
            MockURLProtocol.registerMockError(at: url, error: MockPSIServiceError.unknown)
        }
        URLProtocol.registerClass(MockURLProtocol.self)
    }

    private func unregisterAPIMocks() {
        MockURLProtocol.clearAllMocks()
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }

}

private enum MockPSIServiceError: Error {
    case unknown
}
