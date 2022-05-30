import Foundation

extension URLRequest {
    init?(api: APIProtocol) {
        guard let url = api.url else {
            return nil
        }
        
        self.init(url: url)
        self.httpMethod = "\(api.method)"
        
        if let postableAPI = api as? Postable {
            self.addValue(postableAPI.identifier ?? "", forHTTPHeaderField: "identifier")
            self.addValue(postableAPI.contentType ?? "", forHTTPHeaderField: "Content-Type")
            self.httpBody = postableAPI.body
        }
    }
}
