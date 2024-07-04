import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let tokenKey = "accessToken"
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                let isSuccess = KeychainWrapper.standard.set(token, forKey: tokenKey)
                guard isSuccess else {
                    print("Failed to save token to Keychain")
                    return
                }
            } else {
                let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: tokenKey)
                guard removeSuccessful else {
                    print("Failed to remove token from Keychain")
                    return
                }
            }
        }
    }
}
