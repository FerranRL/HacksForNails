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
    func fetchAppointments(for stylistID: String, on selectedDate: Date) {
        let db = Firestore.firestore()
        let startOfDay = Calendar.current.startOfDay(for: selectedDate) // Inicio del día seleccionado
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)! // Fin del día seleccionado
        
        db.collection("stylists").document(stylistID).collection("appointments")
            .whereField("date", isGreaterThanOrEqualTo: startOfDay)
            .whereField("date", isLessThan: endOfDay)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error obteniendo citas: \(error)")
                    return
                }
                
                self.appointments = querySnapshot?.documents.compactMap { document -> Appointment? in
                    let data = document.data()
                    let timeString = data["time"] as? String ?? ""
                    let startTime = self.extractStartTime(from: timeString)
                    let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                    return Appointment(
                        id: document.documentID,
                        clientID: data["clientID"] as? String ?? "",
                        price: data["price"] as? String ?? "",
                        saloon: data["saloon"] as? String ?? "",
                        service: data["service"] as? String ?? "",
                        serviceTime: data["serviceTime"] as? String ?? "",
                        time: timeString,
                        prepaid: data["prepaid"] as? Bool ?? false,
                        startTime: startTime,
                        date: date
                    )
                }.sorted(by: { ($0.startTime ?? Date()) < ($1.startTime ?? Date()) }) ?? []
            }
    }
    
    // Función para extraer la hora de inicio de un rango de horas
        private func extractStartTime(from timeRange: String) -> Date? {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.locale = Locale(identifier: "es_ES")
            
            // Extraer la primera parte del rango de tiempo
            let timeComponents = timeRange.components(separatedBy: " - ")
            guard let firstTime = timeComponents.first else { return nil }
            
            // Convertir la hora de inicio a Date
            return formatter.date(from: firstTime)
        }
    
    func initializeAppointmentsStructure(for stylistID: String) {
            let db = Firestore.firestore()
            let stylistRef = db.collection("stylists").document(stylistID)
            
            // Comprobar si la subcolección 'appointments' ya tiene documentos
            stylistRef.collection("appointments").getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error al verificar la estructura de citas: \(error)")
                    return
                }
                
                // Si no hay citas, inicializar con un documento vacío opcionalmente
                if snapshot?.isEmpty == true {
                    stylistRef.collection("appointments").addDocument(data: [:]) { error in
                        if let error = error {
                            print("Error creando la subcolección de citas: \(error)")
                        } else {
                            print("Subcolección de citas creada correctamente para el estilista \(stylistID).")
                        }
                    }
                } else {
                    print("La subcolección de citas ya existe para el estilista \(stylistID).")
                }
            }
        }
        
        // Función para añadir citas de ejemplo a un estilista
        func addSampleAppointments(for stylistID: String) {
            let db = Firestore.firestore()
            let stylistRef = db.collection("stylists").document(stylistID).collection("appointments")
            
            let sampleAppointments = [
                [
                    "clientID": "cliente1",
                    "price": "20",
                    "saloon": "Saloon A",
                    "service": "Manicura Básica",
                    "serviceTime": "30 minutos",
                    "time": "10:00 - 10:30",
                    "prepaid": false,
                    "date": Timestamp(date: Date())
                ],
                [
                    "clientID": "cliente2",
                    "price": "35",
                    "saloon": "Saloon B",
                    "service": "Pedicura Completa",
                    "serviceTime": "45 minutos",
                    "time": "11:00 - 11:45",
                    "prepaid": false,
                    "date": Timestamp(date: Date())
                ],
                [
                    "clientID": "cliente3",
                    "price": "50",
                    "saloon": "Saloon C",
                    "service": "Nail Art",
                    "serviceTime": "60 minutos",
                    "time": "12:00 - 13:00",
                    "prepaid": false,
                    "date": Timestamp(date: Date())
                ]
            ]
            
            // Añadir citas de ejemplo
            for appointment in sampleAppointments {
                stylistRef.addDocument(data: appointment) { error in
                    if let error = error {
                        print("Error añadiendo la cita: \(error)")
                    } else {
                        print("Cita de ejemplo añadida correctamente.")
                    }
                }
            }
        }
}
