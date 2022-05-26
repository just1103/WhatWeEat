import Foundation

struct FirstLaunchChecker {
    static func isFirstLaunched() -> Bool {
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "isFirstLaunched") == nil {
            UserDefaults.standard.set(false, forKey: "isFirstLaunched")
            return true
        } else {
            return false
        }
    }
}
