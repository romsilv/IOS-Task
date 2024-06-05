import Foundation
import Combine

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    @Published var currentLanguage: String = "en"

    func setLanguage(languageCode: String) {
        guard currentLanguage != languageCode else { return }
        currentLanguage = languageCode
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        NotificationCenter.default.post(name: .languageChanged, object: nil)
    }
}

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}
