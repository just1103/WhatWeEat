import Foundation

class MenuNation {
    var isChecked: Bool = false
    let kind: Nation
    let descriptionText: String
    
    init(kind: Nation, descriptionText: String) {
        self.kind = kind
        self.descriptionText = descriptionText
    }
    
    func toggleChecked() {
        isChecked.toggle()
    }
}
