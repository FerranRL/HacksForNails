//
//  View+Extension.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 20/6/24.
//

import SwiftUI

extension View {
    func applyBackground() -> some View {
        self.background(Color.black)
            .edgesIgnoringSafeArea(.all)
    }
    
    func applyImageBackground(_ imageName: String) -> some View {
        self.background(
            Image(imageName)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.5)
            )
    }
}

