import Foundation

struct WhatWeEatBaseURL: BaseURLProtocol {
    let baseURL: String = "http://localhost:8080/"  // TODO: 추가
}

struct RandomMenuAPI: Gettable {
    let url: URL?
    let method: HttpMethod = .get
    
    init(baseURL: BaseURLProtocol = WhatWeEatBaseURL()) {
        self.url = URL(string: "\(baseURL.baseURL)menu/random")
    }
}

struct CreateGroupAPI: Postable {
    let url: URL?
    let method: HttpMethod = .post
    var identifier: String?
    var contentType: String?
    var body: Data?
    
    init(baseURL: BaseURLProtocol = WhatWeEatBaseURL()) {
        self.url = URL(string: "\(baseURL.baseURL)group")
    }
}
