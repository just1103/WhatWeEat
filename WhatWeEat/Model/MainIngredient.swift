import Foundation

class MainIngredient {
    enum Kind {
        case rice, noodle, soup, hateAll
    }
    
    var isChecked: Bool = false
    let kind: Kind
    let descriptionText: String
    
    init(kind: Kind, descriptionText: String) {
        self.kind = kind
        self.descriptionText = descriptionText
    }
    
    func toggleChecked() {
        isChecked.toggle()
    }
}
