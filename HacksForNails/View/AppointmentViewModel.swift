//
//  AppointmentViewModel.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 12/9/24.
//
import Foundation
import FirebaseFirestore


class AppointmentViewModel: ObservableObject {
    @Published var appointments: [Appointment] = []
    
    // Función para obtener las citas de Firebase
    func fetchAppointments(stylistID: String) {
        let db = Firestore.firestore()
        db.collection("stylists").document(stylistID).collection("appointments")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error obteniendo citas: \(error)")
                    return
                }
                
                self.appointments = querySnapshot?.documents.compactMap { document -> Appointment? in
                    let data = document.data()
                    return Appointment(
                        id: document.documentID,
                        clientID: data["clientID"] as? String ?? "",
                        price: data["price"] as? String ?? "",
                        saloon: data["saloon"] as? String ?? "",
                        service: data["service"] as? String ?? "",
                        serviceTime: data["serviceTime"] as? String ?? "",
                        time: data["time"] as? String ?? "",
                        prepaid: data["prepaid"] as? Bool ?? false
                    )
                } ?? []
            }
    }
}
