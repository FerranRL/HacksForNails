import SwiftUI

struct ServiceDetailView: View {
    let service: ServiceData
    let preloadedImage: UIImage?
    @State private var downloadedImage: UIImage? = nil
    @State private var isLoading = true
    @Environment(\.presentationMode) var presentationMode
    @State private var contentHeight: CGFloat = 0

    @State private var selectedStylist: Stylist?
    @State private var isStylistSelected = false

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Color.black.ignoresSafeArea()

                if isLoading {
                    LoadingView()
                } else {
                    ScrollView(contentHeight > geometry.size.height ? .vertical : []) {
                        VStack(spacing: 0) {
                            ZStack(alignment: .bottomLeading) {
                                // Fondo de la imagen
                                Image(uiImage: preloadedImage ?? downloadedImage ?? UIImage(named: "placeholder")!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width, height: geometry.size.height * 3 / 4)
                                    .clipped()
                                    .ignoresSafeArea(edges: .top)

                                // Degradado encima de la imagen
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.black.opacity(0), Color.black]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .frame(height: geometry.size.height * 3 / 4)
                                .ignoresSafeArea(edges: .top)

                                VStack(alignment: .leading, spacing: 16) {
                                    // Título y descripción encima de la imagen
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
                                        Spacer()
                                    }
                                    .font(.headline)
                                    .padding(.horizontal)
                                }
                                .padding(.top, 50)
                            }

                            // Contenido principal de la vista después de la imagen
                            serviceDetailsContent()
                        }
                        .background(GeometryReader { geo in
                            Color.clear.onAppear {
                                self.contentHeight = geo.size.height
                            }
                        })
                    }
                }

                bottomBar(price: formattedPrice(service.price))
            }
            .navigationBarHidden(true)
            .onAppear { loadImage() }
        }
    }

    private func loadImage() {
        if preloadedImage != nil {
            isLoading = false
        } else if let imageURL = service.imageURL {
            downloadImage(from: imageURL)
        } else {
            isLoading = false
        }
    }

    private func serviceDetailsContent() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            stylistSelectionSection()
            
            dateTimePickerSection()
        }
    }

    private func stylistSelectionSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            if let stylist = selectedStylist {
                HStack {
                    Image(stylist.imageName)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
                    Text(stylist.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal)
            } else {
                NavigationLink(destination: StylistSelectionView(selectedStylist: $selectedStylist)) {
                    Text("Selecciona estilista")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 45)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom, 20)
    }

    private func dateTimePickerSection() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Selecciona fecha y hora")
                    .font(.body)
                    .bold()
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            HorizontalDateTimePicker()
                .disabled(!isStylistSelected)
                .padding(.horizontal)
        }
    }

    private func bottomBar(price: String) -> some View {
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
                Text(price)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.trailing, 25)
                Spacer()
                Button(action: {
                    // Acción para reservar
                }) {
                    Text("Reservar")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 45, maxHeight: 45)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                }
                .disabled(!isStylistSelected)
                .padding(.horizontal)
            }
        }
        .padding(.top, 50)
        .padding(.leading, 10)
        .ignoresSafeArea(edges: .top)
    }

    private func downloadImage(from url: String) {
        guard let imageURL = URL(string: url) else {
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self.downloadedImage = image
                }
                self.isLoading = false
            }
        }.resume()
    }

    private func formattedPrice(_ price: Double) -> String {
        price == floor(price) ? String(format: "%.0f€", price) : String(format: "%.2f€", price)
    }
}


