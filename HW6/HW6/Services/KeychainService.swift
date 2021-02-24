//
//  KeychainService.swift
//  HW6
//
//  Created by Aliona Starunska on 23.02.2021.
//

import Foundation
import SwiftKeychainWrapper

protocol KeychainService {
    func save(token: String)
    func fetchToken() -> String?
    func deleteToken()
}

class DefaultKeychainService: KeychainService {
    
    func save(token: String) {
        KeychainWrapper.standard.set(.token, forKey: .tokenKey)
    }
    
    func fetchToken() -> String? {
        let token: String? = KeychainWrapper.standard.string(forKey: .tokenKey)
        return token
    }
    
    func deleteToken() {
        KeychainWrapper.standard.removeObject(forKey: .tokenKey)
    }
    
}

fileprivate extension String {
    static var token: String = "Token"
    static var tokenKey: String = "TokenKey"
}
