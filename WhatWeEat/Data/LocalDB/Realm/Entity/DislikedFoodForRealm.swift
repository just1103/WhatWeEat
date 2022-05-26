import Foundation
import RealmSwift

// TODO: Remote 서버에 못먹는음식 데이터 보낼 때, Model 타입 확인
class DislikedFoodForRealM: Object {
    @Persisted var name: String
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
