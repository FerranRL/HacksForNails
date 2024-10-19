//
//  ServiceCard.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 26/6/24.
//

import SwiftUI

struct ServiceCard: View {
    let service: ServiceData
    @State private var preloadedImage: UIImage? = nil  // Almacena la imagen descargada

    var body: some View {
        ZStack {
            // Imagen de fondo desde una URL
            if let preloadedImage = preloadedImage {
                // Si ya tenemos la imagen cargada, la mostramos
                Image(uiImage: preloadedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 315, height: 487)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } else if let urlString = service.imageURL, let url = URL(string: urlString) {
                // Cargamos la imagen desde la URL usando AsyncImage
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()  // Muestra un spinner mientras se carga
                            .frame(width: 315, height: 487)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 315, height: 487)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .onAppear {
                                // Capturamos los datos de la imagen descargada
                                if let data = try? Data(contentsOf: url) {
                                    preloadedImage = UIImage(data: data)
                                }
                            }
                    case .failure:
                        Image("placeholder")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 315, height: 487)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image("placeholder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 315, height: 487)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }

            // Degradado superpuesto
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.9)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 187)
            .padding(.top, 300)
            .clipShape(RoundedRectangle(cornerRadius: 15))

            // Contenido
            VStack(alignment: .leading, spacing: 10) {
                Spacer()

                Text(service.title)
                    .font(.title)
                    .fontWeight(.light)
                    .foregroundColor(.white)

                HStack {
                    Text(formattedPrice(service.price))
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)

                    Spacer()

                    // Navegar a ServiceDetailView pasando la imagen precargada
                    NavigationLink(destination: ServiceDetailView(service: service, preloadedImage: preloadedImage)) {
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

    func formattedPrice(_ price: Double) -> String {
        if price == floor(price) {
            return String(format: "%.0f€", price)
        } else {
            return String(format: "%.2f€", price)
        }
    }
}
