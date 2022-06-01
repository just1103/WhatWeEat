import Foundation
import RealmSwift

struct RealmManager {
    static var shared = RealmManager()
    let realm = try! Realm()
    
    private init() { }
    
    func deleteAndCreate(_ checkedFoods: [DislikedFoodCell.DislikedFood]) {
        try! realm.write {
            realm.deleteAll()
            
            checkedFoods.forEach {
                let dislikedFood = DislikedFoodForRealM(name: $0.name)
                realm.add(dislikedFood)
            }
        }
    }

    func read() -> [String] {
        var checkedDislikedFoods = [String]()
        let checkedFoodsFromRealm = realm.objects(DislikedFoodForRealM.self)
        checkedFoodsFromRealm.forEach {
            checkedDislikedFoods.append($0.name)
        }
        
        return checkedDislikedFoods
    }
}
