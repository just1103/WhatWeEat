import Foundation

struct ResultSubmission: Codable {
    let gameAnswer: GameAnswer
    let dislikedFoods: [DislikedFood.Kind]
    let pinNumber: String?
    let token: String
}
