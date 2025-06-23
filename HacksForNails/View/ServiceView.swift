//
//  ServiceView.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 10/10/24.
//

import SwiftUI

struct ServiceView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var loginModel: LoginViewModel = LoginViewModel.shared
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                    Image("bg2")
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ServiceView()
}
