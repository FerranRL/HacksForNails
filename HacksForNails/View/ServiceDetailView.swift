//
//  ServiceDetailView.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 19/10/24.
//

import SwiftUI

struct ServiceDetailView: View {
    let service: ServiceData  // El servicio que se mostrará
    let preloadedImage: UIImage?  // Imagen cargada previamente (opcional)
    @State private var downloadedImage: UIImage? = nil  // Imagen descargada manualmente si es necesario
    @State private var isLoading = true  // Estado para controlar el loader
    
    var body: some View {
        Group {
            if isLoading {
                // Mostrar el loader mientras se determina la imagen
                VStack {
                    ProgressView("Cargando...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .font(.title2)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Mostrar la vista de detalles solo cuando la imagen esté lista
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Mostrar la imagen precargada o la imagen descargada
                        if let image = preloadedImage ?? downloadedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            // Mostrar un placeholder si no hay imagen
                            Image("placeholder")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        // Mostrar el resto del contenido después de que la imagen esté cargada
                        Text(service.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(service.descripcion)
                            .font(.body)
                            .foregroundColor(.gray)

                        HStack {
                            Text("Precio: \(formattedPrice(service.price))")
                            Spacer()
                            Text("Duración: \(service.duracion) minutos")
                        }
                        .font(.headline)

                        Text("Categorías:")
                            .font(.headline)
                        Text(service.categorias.joined(separator: ", "))
                            .font(.body)
                            .foregroundColor(.gray)

                        Spacer()
                    }
                    .padding()
                }
                .navigationTitle("Detalles del Servicio")
            }
        }
        .onAppear {
            if preloadedImage != nil {
                // Si ya tenemos la imagen precargada, no hay necesidad de descargarla
                isLoading = false
            } else if let imageURL = service.imageURL {
                // Si no hay imagen precargada, descargar la imagen
                downloadImage(from: imageURL)
            } else {
                isLoading = false  // No hay imagen, ocultamos el loader
            }
        }
    }
    
    // Función para descargar la imagen manualmente
    private func downloadImage(from url: String) {
        guard let imageURL = URL(string: url) else {
            isLoading = false
            return
        }
        
        // Usar URLSession para descargar la imagen
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.downloadedImage = image  // Actualizar la imagen descargada
                    self.isLoading = false  // Ocultar el loader
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false  // Manejar el error
                }
            }
        }.resume()
    }

    // Función para formatear el precio
    func formattedPrice(_ price: Double) -> String {
        if price == floor(price) {
            return String(format: "%.0f€", price)
        } else {
            return String(format: "%.2f€", price)
        }
    }
}
