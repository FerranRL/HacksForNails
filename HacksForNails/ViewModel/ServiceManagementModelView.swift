//
//  ServiceManagementModelView.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 18/10/24.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class ServiceManagementModelView: ObservableObject {
    @Published var services: [ServiceData] = []
    @Published var searchResult: ServiceData? = nil  // Resultado de búsqueda
    @Published var isLoading = false  // Indicador de carga

    private var db = Firestore.firestore()
    private var storage = Storage.storage()
    
    // Función para recuperar todos los servicios desde Firestore
    func fetchAllServices() {
        isLoading = true
        db.collection("services").getDocuments { snapshot, error in
            self.isLoading = false
            if let error = error {
                print("Error al recuperar servicios: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No se encontraron servicios.")
                return
            }
            
            self.services = documents.compactMap { document in
                let data = document.data()
                return self.parseServiceData(from: data, id: document.documentID)
            }
        }
    }
    
    // Función para actualizar un servicio existente
    func updateService(service: ServiceData, image: Data?, completion: @escaping (Bool) -> Void) {
        isLoading = true
        let serviceRef = db.collection("services").document(service.id)
        
        // Subir la imagen primero, si se proporciona
        if let image = image {
            uploadImage(image: UIImage(data: image)!, serviceId: service.id) { url in
                var updatedService = service
                updatedService.imageURL = url
                self.saveServiceData(service: updatedService, reference: serviceRef, completion: completion)
            }
        } else {
            self.saveServiceData(service: service, reference: serviceRef, completion: completion)
        }
    }
    
    // Función para añadir un nuevo servicio
    func addNewService(service: ServiceData, image: UIImage?, completion: @escaping (Bool) -> Void) {
        isLoading = true
        let serviceRef = db.collection("services").document()  // Crear un nuevo documento
        
        // Subir la imagen primero, si se proporciona
        if let image = image {
            uploadImage(image: image, serviceId: serviceRef.documentID) { url in
                var newService = service
                newService.imageURL = url
                self.saveServiceData(service: newService, reference: serviceRef, completion: completion)
            }
        } else {
            self.saveServiceData(service: service, reference: serviceRef, completion: completion)
        }
    }
    
    // Función para buscar un servicio por tratamiento
    func searchService(byTratamiento tratamiento: String) {
        isLoading = true
        db.collection("services")
            .whereField("tratamiento", isEqualTo: tratamiento)
            .getDocuments { snapshot, error in
                self.isLoading = false
                if let error = error {
                    print("Error al buscar servicios: \(error.localizedDescription)")
                    return
                }
                
                if let document = snapshot?.documents.first {
                    self.searchResult = self.parseServiceData(from: document.data(), id: document.documentID)
                } else {
                    self.searchResult = nil
                    print("No se encontró ningún servicio con el tratamiento: \(tratamiento)")
                }
            }
    }
    
    // Subir imagen al Storage y obtener la URL
    func uploadImage(image: UIImage, serviceId: String, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }

        let storageRef = storage.reference().child("services/\(serviceId).jpg")
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Error al subir la imagen: \(error.localizedDescription)")
                completion(nil)
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error al obtener la URL de la imagen: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                completion(url?.absoluteString)
            }
        }
    }
    
    // Guardar los datos de un servicio en Firestore
    private func saveServiceData(service: ServiceData, reference: DocumentReference, completion: @escaping (Bool) -> Void) {
        let data: [String: Any] = [
            "tratamiento": service.title,
            "descripcion": service.descripcion,
            "precio": service.price,
            "duracion": service.duracion,
            "categorias": service.categorias,
            "imageURL": service.imageURL ?? ""
        ]
        
        reference.setData(data) { error in
            self.isLoading = false
            if let error = error {
                print("Error al guardar el servicio: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    // Función para convertir los datos recuperados de Firestore a un objeto ServiceData
    private func parseServiceData(from data: [String: Any], id: String) -> ServiceData? {
        guard let tratamiento = data["tratamiento"] as? String,
              let descripcion = data["descripcion"] as? String,
              let precio = data["precio"] as? Double,
              let duracion = data["duracion"] as? Int,
              let categorias = data["categorias"] as? [String] else {
            return nil
        }
        
        let imageURL = data["imageURL"] as? String
        
        return ServiceData(id: id, imageURL: imageURL, title: tratamiento, price: precio, duracion: duracion, descripcion: descripcion, categorias: categorias)
    }
}

