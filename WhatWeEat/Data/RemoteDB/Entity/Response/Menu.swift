import Foundation

struct Menu: Codable {
    let name: String
    let imageURL: String
    let keywords: [String]? // TODO: enum으로 구분? 서버 협의 필요
}
