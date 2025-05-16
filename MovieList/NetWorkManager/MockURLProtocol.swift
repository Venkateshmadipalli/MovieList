//
//  MockURLProtocol.swift
//  MovieList
//
//  Created by Venkatesh MAdipalli on 16/05/25.
//

import Foundation
class URLProtocolMock: URLProtocol {
    static var testURLs = [URL: Data]()
    static var responseData: Data?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let url = request.url, let data = URLProtocolMock.testURLs[url] {
            self.client?.urlProtocol(self, didLoad: data)
        }

        if let data = URLProtocolMock.responseData {
            self.client?.urlProtocol(self, didLoad: data)
        }

        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
