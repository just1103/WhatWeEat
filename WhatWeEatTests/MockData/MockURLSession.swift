import Foundation
@testable import WhatWeEat

class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> Void = {}
    
    override func resume() {
        resumeDidCall()
    }
    
    override func cancel() {}
}

class MockURLSession: URLSessionProtocol {
    var isRequestSuccess: Bool
    var sessionDataTask: MockURLSessionDataTask?
    
    init(isRequestSuccess: Bool = true) {
        self.isRequestSuccess = isRequestSuccess
    }
    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        let sucessResponse = HTTPURLResponse(
            url: request.url!,
            statusCode: 200,
            httpVersion: "2",
            headerFields: nil
        )
        let failureResponse = HTTPURLResponse(
            url: request.url!,
            statusCode: 402,
            httpVersion: "2",
            headerFields: nil
        )
        
        let sessionDataTask = MockURLSessionDataTask()
        
        guard
            let path = Bundle(for: type(of: self)).path(forResource: "MockRandomMenu", ofType: "json"),
            let jsonString = try? String(contentsOfFile: path)
        else {
            fatalError()
        }
        let data = jsonString.data(using: .utf8)
        
        if isRequestSuccess {
            sessionDataTask.resumeDidCall = {
                completionHandler(data, sucessResponse, nil)
            }
        } else {
            sessionDataTask.resumeDidCall = {
                completionHandler(nil, failureResponse, nil)
            }
        }
        self.sessionDataTask = sessionDataTask
        
        return sessionDataTask
    }
}
