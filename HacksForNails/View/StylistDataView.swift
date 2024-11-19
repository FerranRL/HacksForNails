//
//  StylistDataView.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 19/11/24.
//

//
//  StylistDataView.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 19/11/24.
//

import SwiftUI

struct StylistDataView: View {
    var stylistName: String
    var stylistImage: String // Imagen del estilista
    var stylistWorks: [String] // Trabajos realizados
    var onSelect: () -> Void // Acción para seleccionar al estilista
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // Fondo negro
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Imagen principal
                        Image(stylistImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                            .clipped()
                            .ignoresSafeArea(edges: .top)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            // Nombre del estilista
                            Text(stylistName)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Trabajos realizados")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.top, 10)
                            
                            // Galería de trabajos
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(stylistWorks, id: \.self) { work in
                                        Image(work)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            // Botón "Seleccionar estilista"
                            Button(action: {
                                //onSelect() // Llama a la acción de seleccionar estilista
                                presentationMode.wrappedValue.dismiss() // Cierra la vista
                            }) {
                                Text("Volver")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, minHeight: 45, maxHeight: 45)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                                    .padding(.top, 20)
                            }
                        }
                        .padding()
                    }
                }
                
                // Botón "Back"
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 30)
                    Spacer()
                }
                .padding()
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true) // Oculta la barra de navegación predeterminada
    }
}

#Preview {
    StylistDataView(
        stylistName: "Irina",
        stylistImage: "profile_photo", // Cambiar por el nombre real de la imagen
        stylistWorks: ["work1", "work2", "work3", "work4"], // Cambiar por nombres reales de las imágenes
        onSelect: {
            print("Estilista seleccionado") // Acción de ejemplo
        }
    )
}
