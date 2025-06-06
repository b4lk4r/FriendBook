
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let keychain = AppModule.shared.resolve(KeychainManagerInput.self)
        
        if keychain.get(forKey: KeychainKeys.gigaChatAPIKeyName) == nil {
            let apiKey = KeychainKeys.gigaChatAPIKey // имитация получения ключа с бека
            
            if !keychain.save(apiKey, forKey: KeychainKeys.gigaChatAPIKeyName) {
                print("Ключ API не был сохранен в keychain")
            }
        }
        
        if keychain.get(forKey: KeychainKeys.geminiAPIKeyName) == nil {
            let apiKey = KeychainKeys.geminiAPIKey // имитация получения ключа с бека
            
            if !keychain.save(apiKey, forKey: KeychainKeys.geminiAPIKeyName) {
                print("Ключ API не был сохранен в keychain")
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


}

