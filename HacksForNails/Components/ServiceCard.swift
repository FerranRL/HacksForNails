//
//  ServiceCard.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 26/6/24.
//

import SwiftUI

struct ServiceCard: View {
    let imageName: String
    let title: String
    let price: String

    var body: some View {
        ZStack {
            // Imagen de fondo
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 487)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            // Degradado superpuesto
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.9)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 487)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            // Contenido
            VStack(alignment: .leading, spacing: 10) {
                Spacer()
                
                Text(title)
                    .font(.title)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                
                HStack {
                    Text(price)
                        .font(.title3)
                        .fontWeight(.light)
                        .frame(height: 40)
                        .padding(.horizontal, 20)
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    
                    Spacer()
                    
                    Button {
                        print("Botón Ver más")
                    } label: {
                        Text("Ver más")
                            .fontWeight(.light)
                            .foregroundColor(.black)
                            .frame(width: 180, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(Color.white)
                            )
                    }
                }
                .padding(.bottom, 10)
            }
            .padding()
        }
        .frame(height: 487)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(radius: 3)
    }
}

