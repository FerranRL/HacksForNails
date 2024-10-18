//
//  ServiceManagementView.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 18/10/24.
//

import SwiftUI
import PhotosUI

struct ServiceManagementView: View {
    @StateObject var serviceModel = ServiceManagementModelView()
    @State private var selectedService: ServiceData? = nil
    @State private var searchQuery: String = ""
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var selectedImageData: Data? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                // Buscador
                HStack {
                    TextField("Buscar por tratamiento", text: $searchQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        serviceModel.searchService(byTratamiento: searchQuery)
                    }) {
                        Text("Buscar")
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                }
                .padding()
                
                // Resultado de la búsqueda
                if let service = serviceModel.searchResult {
                    ServiceEditView(service: service)
                } else {
                    Text("No se encontró el servicio.")
                        .foregroundColor(.gray)
                        .padding()
                }
                
                Divider()
                
                // Lista de todos los servicios
                List(serviceModel.services) { service in
                    ServiceEditView(service: service)
                        .environmentObject(serviceModel)
                }
                
                // Botón para añadir un nuevo servicio
                Button(action: {
                    selectedService = ServiceData(id: "", imageURL: nil, title: "", price: 0.0, duracion: 0, descripcion: "", categorias: [])
                }) {
                    Text("Añadir nuevo servicio")
                        .fontWeight(.bold)
                }
                .padding()
            }
            .onAppear {
                serviceModel.fetchAllServices()
            }
            .sheet(isPresented: $showImagePicker) {
                // Siempre muestra el ImagePicker
                ImagePicker(selectedImageData: $selectedImageData)
            }
            .onChange(of: selectedImage) {
                // Convertir UIImage a Data una vez que se seleccione una imagen
                if let image = selectedImage {
                    selectedImageData = image.jpegData(compressionQuality: 0.8)
                }
            }
            .navigationBarTitle("Gestión de Servicios")
        }
    }
}

// Subvista para editar los campos de un servicio
struct ServiceEditView: View {
    @State var service: ServiceData
    @State private var showImagePicker = false
    @State private var selectedImageData: Data? = nil
    @EnvironmentObject var serviceModel: ServiceManagementModelView
    
    var body: some View {
        VStack(alignment: .leading) {
            // Campos de texto para el servicio
            TextField("Tratamiento", text: $service.title)
            TextField("Descripción", text: $service.descripcion)
            TextField("Precio", value: $service.price, formatter: NumberFormatter())
            TextField("Duración", value: $service.duracion, formatter: NumberFormatter())
            TextField("Categorías", text: Binding(
                get: { service.categorias.joined(separator: ", ") },
                set: { service.categorias = $0.components(separatedBy: ", ") }
            ))
            
            // Mostrar la imagen actual del servicio (si tiene)
            if let imageUrl = service.imageURL {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()               // Permitir que la imagen se redimensione
                        .scaledToFit()             // Escalar la imagen para que se ajuste al contenedor
                        .frame(width: 100, height: 100) // Tamaño específico de la imagen
                } placeholder: {
                    ProgressView()                 // Indicador de carga mientras se descarga la imagen
                }
            }

            // Mostrar la imagen seleccionada si existe
            if let imageData = selectedImageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.vertical)
            }

            // Botón para seleccionar la imagen
            HStack(spacing: 20) {
                Button("Seleccionar imagen") {
                    showImagePicker = true
                }
                .buttonStyle(BorderedButtonStyle())
                .tint(.blue)

                // Botón para guardar los cambios
                Button("Guardar") {
                    serviceModel.updateService(service: service, image: selectedImageData) { success in
                        if success {
                            print("Servicio actualizado")
                        } else {
                            print("Error al actualizar el servicio")
                        }
                    }
                }
                .buttonStyle(BorderedButtonStyle())
                .tint(.green)
            }
            .padding(.vertical)
        }
        .sheet(isPresented: $showImagePicker) {
            // Usar ImagePicker para obtener los datos binarios (Data) de la imagen
            ImagePicker(selectedImageData: $selectedImageData)
        }
    }
}

#Preview {
    ServiceManagementView()
}
