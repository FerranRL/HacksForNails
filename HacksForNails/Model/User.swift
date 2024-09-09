//
//  User.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 6/7/24.
//

import Foundation
import SwiftUICore

struct User: Identifiable {
    let id: String
    let email: String
    let fullName: String
    let role: String
    let phone: String?
    let profileImage: String?
    
    var firstName: String {
        return fullName.components(separatedBy: " ").first ?? fullName
    }
}
