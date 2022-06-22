import Foundation

struct TogetherGameSubmittedChecker {
    static var isSubmitted: Bool {
        guard let isTogetherGameSubmitted = UserDefaults.standard.object(forKey: "isTogetherGameSubmitted") as? Bool else {
            return false
        }
        
        if isTogetherGameSubmitted {
            return true
        } else {
            return false
        }
    }
    
    static var latestPinNumber: String {
        guard let pinNumber = UserDefaults.standard.object(forKey: "latestPinNumber") as? String else { return "" }
        return pinNumber
    }
}
