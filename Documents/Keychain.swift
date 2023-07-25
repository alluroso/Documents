//
//  Keychain.swift
//  Documents
//
//  Created by Алексей Калинин on 25.07.2023.
//

import Foundation
import KeychainAccess

class KeyChain {
    
    static let shared = KeyChain()
    
    let keychain = Keychain(service: "com.example.github-token")
    
}
