//
//  StylistSelectionView.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 28/10/24.
//

import SwiftUI

struct StylistSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedStylist: Stylist? // Variable que recibirá el estilista seleccionado
    
    let stylists = [
        Stylist(name: "Irina", rating: 4.8, imageName: "irina_image"),
        Stylist(name: "Laia", rating: 5.0, imageName: "laia_image"),
        Stylist(name: "Primero Disponible", rating: nil, imageName: "placeholder")
    ]

    var body: some View {
        VStack {
            Text("Selecciona tu estilista")
                .font(.title)
                .foregroundColor(.white)
                .padding()

            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem()], spacing: 20) {
                    ForEach(stylists, id: \.name) { stylist in
                        Button(action: {
                            selectedStylist = stylist
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            StylistCard(stylist: stylist)
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color.black.ignoresSafeArea())
    }
}

// Modelo para el estilista
struct Stylist {
    let name: String
    let rating: Double?
    let imageName: String
}

// Tarjeta del estilista
struct StylistCard: View {
    let stylist: Stylist
    
    var body: some View {
        VStack {
            Image(stylist.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Text(stylist.name)
                .foregroundColor(.white)
                .font(.headline)
            
            if let rating = stylist.rating {
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", rating))
                        .foregroundColor(.white)
                }
            }
        }
        .frame(width: 150, height: 180)
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
