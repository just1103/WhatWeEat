import Foundation

struct FirstLaunchChecker {
    static func isFirstLaunched() -> Bool {
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "isFirstLaunched") == nil {
            return true
        } else {
            return false
        }
    }
}
