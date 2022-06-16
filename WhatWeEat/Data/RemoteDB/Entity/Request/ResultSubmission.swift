import Foundation

struct ResultSubmission: Codable {
    let gameAnswer: GameAnswer
    let dislikedFoods: [DislikedFood.Kind]
    let pinNumber: String?  // TODO: String으로 바꿔도 될듯, solo면 없으니까 옵셔널로 변경 필요 (서버 확인)
    let token: String
}
