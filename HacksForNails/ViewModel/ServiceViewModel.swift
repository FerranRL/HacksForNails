//
//  ServiceViewModel.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 14/10/24.
//

import Firebase
import FirebaseFirestore
import SwiftUI

class ServiceViewModel: ObservableObject {
    @Published var servicesByCategory: [String: [ServiceData]] = [:]  // Almacena los servicios clasificados por categoría
    
    private var db = Firestore.firestore()
    
    private let categoryMapping: [String: String] = [
            "Promo": "Ofertas",  // Mapeo de "Promo" a "Ofertas"
            // Puedes agregar otros mapeos aquí si es necesario
        ]
    
    init() {
        fetchServicesFromFirebase()
    }
    
    func fetchServicesFromFirebase() {
        db.collection("services").getDocuments { snapshot, error in
            if let error = error {
                print("Error al recuperar servicios: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No se encontraron servicios.")
                return
            }
            
            var servicesByCategoryTemp: [String: [ServiceData]] = [:]
            
            for document in documents {
                let data = document.data()
                
                // Verificamos los campos necesarios
                guard let title = data["tratamiento"] as? String,
                      let price = data["precio"] as? Double,
                      let descripcion = data["descripcion"] as? String,
                      let categorias = data["categorias"] as? [String],
                      let duracion = data["duracion"] as? Int else {
                    continue
                }
                
                let imageURL = data["imageURL"] as? String  // Imagen puede ser nil si no existe en Firebase

                // Crear un objeto ServiceData para cada documento
                let service = ServiceData(
                    id: document.documentID,  // Usamos el documentID como identificador único
                    imageURL: imageURL,
                    title: title,
                    price: price,
                    duracion: duracion,
                    descripcion: descripcion,
                    categorias: categorias
                )
                
                // Mapear categorías
                for categoria in categorias {
                    let mappedCategory = self.categoryMapping[categoria] ?? categoria
                    
                    if servicesByCategoryTemp[mappedCategory] == nil {
                        servicesByCategoryTemp[mappedCategory] = []
                    }
                    servicesByCategoryTemp[mappedCategory]?.append(service)
                }
            }
            
            // Actualizar la propiedad publicada en el hilo principal
            DispatchQueue.main.async {
                self.servicesByCategory = servicesByCategoryTemp
            }
        }
    }
}
