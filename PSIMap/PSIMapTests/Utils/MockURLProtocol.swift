//
//  MockURLProtocol.swift
//  PSIMapTests
//
//  Created by Kevin Lo on 27/10/2019.
//  Copyright © 2019 Zuhlke Engineering HK Limited. All rights reserved.
//

import Foundation

private let MockRequestKey = "isMock"

class MockURLProtocol: URLProtocol {

    private static var mockResponse = [URL: (status: Int, body: Data)]()

    private static var mockError = [URL: Error]()

    class func registerMockResponse(at url: URL, status: Int, body: Data) {
        mockResponse[url] = (status: status, body: body)
    }

    class func registerMockError(at url: URL, error: Error) {
        mockError[url] = error
    }

    class func clearAllMocks() {
        mockResponse.removeAll()
        mockError.removeAll()
    }

    override class func canInit(with request: URLRequest) -> Bool {
        guard let url = request.url else {
            return false
        }
        return mockResponse.keys.contains(url) || mockError.keys.contains(url)
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let url = request.url else {
            let error = NSError(
                domain: URLError.errorDomain,
                code: URLError.cannotLoadFromNetwork.rawValue,
                userInfo: nil
            )
            client?.urlProtocol(self, didFailWithError: error as Error)
            client?.urlProtocolDidFinishLoading(self)
            return
        }

        if let response = type(of: self).mockResponse[url] {
            let urlResponse = HTTPURLResponse(
                url: url,
                statusCode: response.status,
                httpVersion: nil,
                headerFields: nil
            ) ?? URLResponse()
            client?.urlProtocol(self, didReceive: urlResponse, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: response.body)
        }
        else if let error = type(of: self).mockError[url] {
            client?.urlProtocol(self, didFailWithError: error)
        }
        else {
            let error = NSError(
                domain: URLError.errorDomain,
                code: URLError.cannotLoadFromNetwork.rawValue,
                userInfo: nil
            )
            client?.urlProtocol(self, didFailWithError: error as Error)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // Do nothing in mock
    }

}

extension MockURLProtocol {

    private class func isInternalRequest(_ request: URLRequest) -> Bool {
        guard let isInternal = URLProtocol.property(forKey: MockRequestKey, in: request) as? Bool else {
            return false
        }
        return isInternal
    }

}
