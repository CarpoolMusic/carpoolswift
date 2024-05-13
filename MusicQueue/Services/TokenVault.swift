/**
 This class provides methods for storing and retrieving tokens in the keychain.
 */
import SwiftUI
import Security

class TokenVault {
    
    /**
     Upserts a token to the keychain.
     
     - Parameters:
     - token: The token to be stored in the keychain.
     */
    static func upsertTokenToKeychain(token: String) -> Void {
        let data = Data(token.utf8)
        let service = "test"
        let account = "test"
        
        // Define the query parameters for updating or adding an item to the keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        // Define the attributes to be updated or added to the keychain
        let updateAttributes: [String: Any] = [
            kSecValueData as String: data
        ]
        
        // Update or add the item to the keychain
        let updateStatus = SecItemUpdate(query as CFDictionary, updateAttributes as CFDictionary)
        
        if updateStatus == errSecItemNotFound {
            SecItemAdd(query.merging(updateAttributes) { (_, new) in new } as CFDictionary, nil)
        }
    }
    
    /**
     Retrieves a token from the keychain.
     
     - Returns:
     The retrieved token from the keychain, or nil if no token is found.
     */
    static func getTokenFromKeychain() -> String? {
        let service = "test"
        let account = "test"
        
        // Define the query parameters for retrieving an item from the keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        
        // Retrieve the item from the keychain
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}
