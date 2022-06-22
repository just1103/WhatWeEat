import Foundation

protocol APIProtocol {
    var url: URL? { get }
    var method: HttpMethod { get }
}

protocol Gettable: APIProtocol { }

protocol Postable: Requestable {
    var contentType: String? { get }
    var body: Data? { get }
}

protocol Deletable: Requestable { }

protocol Puttable: Requestable { }

protocol Requestable: APIProtocol { }

enum HttpMethod {
    case get
    case post
    case delete
    case put
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .put:
            return "PUT"
        }
    }
}
