import Foundation

class MainIngredient {
    enum Kind {
        case rice
        case noodle
        case soup
        case hateAll
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
