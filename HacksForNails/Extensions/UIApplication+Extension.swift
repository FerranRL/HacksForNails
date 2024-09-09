//
//  UIApplication+Extension.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 20/6/24.
//

import SwiftUI
import CryptoKit
import AuthenticationServices

extension UIApplication {
    func closeKeyboard() {
        DispatchQueue.main.async {
            self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
    }
    
    func rootController() -> UIViewController {
        guard let window = connectedScenes.first as? UIWindowScene else { return .init() }
        
        guard let viewcontroller = window.windows.last?.rootViewController else { return .init() }
        
        return viewcontroller
    }
}

// MARK: Apple Sign in Helpers
func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
         return String(format: "%02x", $0)
    }.joined()
    
    return hashString
    
}

func randomNonceString2(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-._0123456789")
    var result: String = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength > 0 {
                    return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
    
    
}
