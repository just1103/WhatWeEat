import Foundation
import RealmSwift

struct RealmManager {
    static var shared = RealmManager()
    let realm = try! Realm()
    
    private init() { }
    
    func deleteAndCreate(_ checkedFoods: [DislikedFood]) {
        try! realm.write {
            realm.deleteAll()
            
            checkedFoods.forEach {
                let dislikedFood = DislikedFoodForRealM(kind: $0.kind)
                realm.add(dislikedFood)
            }
        }
    }

    func read() -> [DislikedFood.Kind] {
        var checkedDislikedFoods = [DislikedFood.Kind]()
        let checkedFoodsFromRealm = realm.objects(DislikedFoodForRealM.self)
        checkedFoodsFromRealm.forEach {
            checkedDislikedFoods.append($0.kind)
        }
        
        return checkedDislikedFoods
    }
}
