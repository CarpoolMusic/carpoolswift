//
//  TokenVault.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-10-02.
//

import Security

class TokenVault {
    
    static func upsertTokenToKeychain(token: String) -> Void {
        let data = Data(token.utf8)
        let service = "YourServiceIdentifier" // Replace with your service identifier
        let account = "YourAccountIdentifier" // Replace with your account identifier

        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service,
                                    kSecAttrAccount as String: account]

        let updateAttributes: [String: Any] = [kSecValueData as String: data]

        // Try to update first
        let updateStatus = SecItemUpdate(query as CFDictionary, updateAttributes as CFDictionary)
         if updateStatus == errSecItemNotFound {
        // Item not found, try to add it
        let addStatus = SecItemAdd(query.merging(updateAttributes) { (_, new) in new } as CFDictionary, nil)
        }
    }
    
    static func getTokenFromKeychain() -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecReturnData as String: kCFBooleanTrue!,
                                    kSecMatchLimit as String: kSecMatchLimitOne]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess {
            if let data = item as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }
}
