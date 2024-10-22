import SwiftUI

struct ServiceDetailView: View {
    let service: ServiceData
    let preloadedImage: UIImage?
    @State private var downloadedImage: UIImage? = nil
    @State private var isLoading = true
    @Environment(\.presentationMode) var presentationMode
    @State private var contentHeight: CGFloat = 0 // Variable para almacenar la altura del contenido

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Fondo de la pantalla
                Color.black
                    .ignoresSafeArea()

                Group {
                    if isLoading {
                        VStack {
                            ProgressView("Cargando...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .font(.title2)
                                .padding()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // Usamos GeometryReader dentro del ScrollView para medir el tamaño del contenido
                        ScrollView(contentHeight > geometry.size.height ? .vertical : []) {
                            VStack(spacing: 0) {
                                ZStack(alignment: .topLeading) {
                                    if let image = preloadedImage ?? downloadedImage {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width, height: geometry.size.height * 3 / 4)
                                            .clipped()
                                            .ignoresSafeArea(edges: .top)
                                    } else {
                                        Image("placeholder")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width, height: geometry.size.height * 3 / 4)
                                            .clipped()
                                            .ignoresSafeArea(edges: .top)
                                    }

                                    // Degradado para mejorar la legibilidad del texto
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.black.opacity(0), Color.black]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                    .frame(height: geometry.size.height * 3 / 4)
                                    .ignoresSafeArea(edges: .top)

                                    VStack(alignment: .leading, spacing: 16) {
                                        Text(service.title)
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.horizontal)
                                            .padding(.top, 20)
                                        
                                        Text(service.descripcion)
                                            .font(.body)
                                            .foregroundColor(.white)
                                            .padding(.horizontal)
                                            .padding(.bottom, 20)
                                        
                                        HStack {
                                            Text("Duración \(service.duracion) minutos")
                                                .foregroundColor(.gray)
                                                .padding(.bottom, 20)
                                            Spacer()
                                        }
                                        .font(.headline)
                                        .padding(.horizontal)
                                        
                                        VStack(alignment: .leading, spacing: 16) {
                                            Text("¿Quieres añadir algún complemento?")
                                                .font(.body)
                                                .bold()
                                                .foregroundStyle(.white)
                                            
                                            HStack(spacing: 20) {
                                                complementoButton(title: "Complemento 1")
                                                complementoButton(title: "Complemento 2")
                                                complementoButton(title: "Complemento 3")
                                            }
                                            
                                            NavigationLink(destination: EmptyView()) {
                                                Text("Selecciona estilista")
                                                    .fontWeight(.light)
                                                    .foregroundColor(.black)
                                                    .frame(maxWidth: .infinity, minHeight: 45, maxHeight: 45)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                            .fill(Color.white)
                                                    )
                                            }
                                        }
                                        .padding(.horizontal)
                                        
                                        HStack {
                                            Text("Selecciona fecha y hora")
                                                .font(.body)
                                                .bold()
                                                .foregroundStyle(.white)
                                            
                                            Spacer()
                                            
                                        }
                                        .padding(.horizontal)
                                        .padding(.bottom, 10)
                                        VStack(alignment: .leading) {
                                            HorizontalDateTimePicker()
                                        }

                                        Spacer()
                                    }
                                    .padding(.top, 100)
                                }
                            }
                            .background(GeometryReader { geo in
                                Color.clear.onAppear {
                                    self.contentHeight = geo.size.height // Obtenemos la altura del contenido
                                }
                            })
                        }
                        .ignoresSafeArea(edges: .top)
                    }
                }
                .onAppear {
                    if preloadedImage != nil {
                        isLoading = false
                    } else if let imageURL = service.imageURL {
                        downloadImage(from: imageURL)
                    } else {
                        isLoading = false
                    }
                }

                // Botón de cierre
                VStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.backward.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        }
                        .padding()
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Text("\(formattedPrice(service.price))")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.trailing, 25)
                        Spacer()
                        NavigationLink(destination: EmptyView()) {
                            Text("Reservar")
                                .fontWeight(.light)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, minHeight: 45, maxHeight: 45)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color.white)
                                )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 50)
                .padding(.leading, 10)
                .ignoresSafeArea(edges: .top)
            }
        }
        .navigationBarHidden(true)
    }
    
    private func downloadImage(from url: String) {
        guard let imageURL = URL(string: url) else {
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.downloadedImage = image
                    self.isLoading = false
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
    }

    func formattedPrice(_ price: Double) -> String {
        if price == floor(price) {
            return String(format: "%.0f€", price)
        } else {
            return String(format: "%.2f€", price)
        }
    }

    @ViewBuilder
    func complementoButton(title: String) -> some View {
        Button(action: {
            print(title)
        }) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.white)
                .frame(width: 120, height: 70)
                .background(Color.gray.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
