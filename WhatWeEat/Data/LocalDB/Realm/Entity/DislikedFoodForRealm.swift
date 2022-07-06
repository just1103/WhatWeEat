import Foundation
import RealmSwift

class DislikedFoodForRealM: Object {
    @Persisted var kind: DislikedFood.Kind
    
    convenience init(kind: DislikedFood.Kind) {
        self.init()
        self.kind = kind
    }
}
