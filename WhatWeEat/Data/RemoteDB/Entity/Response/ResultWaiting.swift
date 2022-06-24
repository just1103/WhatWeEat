import Foundation

struct ResultWaiting: Codable {
    let submissionCount: Int
    let isHost: Bool
    let isGameClosed: Bool  // Host가 게임결과확인 버튼을 탭했는지 여부
}
