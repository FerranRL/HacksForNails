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
        Stylist(name: "Irina", imageName: "profile_photo"),
        Stylist(name: "Laia", imageName: "person1"),
        Stylist(name: "Primero Disponible", imageName: "placeholder")
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
                        StylistCard(stylist: stylist) {
                            // Closure que se ejecuta cuando se selecciona el estilista
                            selectedStylist = stylist
                            presentationMode.wrappedValue.dismiss()
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
        let imageName: String
    }
    
    // Tarjeta del estilista
    struct StylistCard: View {
        let stylist: Stylist
        var onSelect: () -> Void
        
        var body: some View {
            VStack {
                Image(stylist.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                Text(stylist.name)
                    .foregroundColor(.white)
                    .font(.headline)
                
                HStack {
                    if stylist.name == "Primero Disponible" {
                        Button(action: {
                            onSelect()
                        }) {
                            Text("+")
                                .font(.caption)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                                .cornerRadius(5)
                            
                        }
                    } else {
                        Button(action: {
                            print("Ver más")
                        }) {
                            Text("Ver ficha")
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(8)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                                .cornerRadius(5)
                            
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            onSelect()
                        }) {
                            Text("+")
                                .font(.caption)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .padding(.horizontal,15)
                                .padding(.vertical, 8)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                                .cornerRadius(5)
                            
                        }
                    }
                    
                    
                }
                .padding(.horizontal, 15)
                
                
            }
            .frame(width: 150, height: 220)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

