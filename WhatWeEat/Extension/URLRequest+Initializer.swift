import Foundation

extension URLRequest {
    init?(api: APIProtocol) {
        guard let url = api.url else {
            return nil
        }
        
        self.init(url: url)
        self.httpMethod = "\(api.method)"
        
        if let postableAPI = api as? Postable,
           let contentType = postableAPI.contentType {
            self.httpBody = postableAPI.body
            self.addValue(contentType, forHTTPHeaderField: "Content-Type")
        }
    }
}
