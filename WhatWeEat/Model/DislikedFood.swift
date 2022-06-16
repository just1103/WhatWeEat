import UIKit
import RealmSwift

class DislikedFood: Hashable {
    enum Kind: String, PersistableEnum, Codable {
        case spicy = "SPICY"
        case intestine = "INTESTINE"
        case sashimi = "SASHIMI"
        case seafood = "SEAFOOD"
        case meat = "MEAT"
    }
    
    var isChecked: Bool = false
    let kind: Kind
    let descriptionImage: UIImage
    let descriptionText: String
    
    init(kind: Kind, descriptionImage: UIImage, descriptionText: String) {
        self.kind = kind
        self.descriptionImage = descriptionImage
        self.descriptionText = descriptionText
    }
    
    func toggleChecked() {
        self.isChecked.toggle()
    }
    
    static func == (lhs: DislikedFood, rhs: DislikedFood) -> Bool {
        return lhs.kind == rhs.kind
    }
    
    func hash(into hasher: inout Hasher) {
       hasher.combine(kind)
    }
}
