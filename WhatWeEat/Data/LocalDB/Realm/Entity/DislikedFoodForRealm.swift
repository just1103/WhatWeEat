import Foundation
import RealmSwift

class DislikedFoodForRealM: Object {
    @Persisted var name: String
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
