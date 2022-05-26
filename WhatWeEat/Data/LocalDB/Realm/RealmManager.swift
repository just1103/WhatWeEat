import Foundation
import RealmSwift

struct RealmManager {
    static var shared = RealmManager()
    let realm = try! Realm()
    
    private init() { }
}
