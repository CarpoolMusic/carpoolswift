//
//  TokenVault.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-10-02.
//

import Security

class TokenVault {
    
    func saveToken(token: String) -> Bool {
        let tokenData = Data(token.utf8)
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: "userAccount",
                                    kSecValueData as String: tokenData]
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            return true
        }
        return false
    }
    
//    func retrieveToken() -> String {
//        var query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
//                                    ]
//    }
}
