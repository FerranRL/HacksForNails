//  StylistScheduleUploader.swift
//  HacksForNails

import Foundation
import FirebaseFirestore

struct StylistSchedule: Codable {
    let stylistID: String
    let weeklySchedule: [String: [String: String]] // Ej: ["Monday": ["start": "10:00", "end": "18:00"]]
}

// Horarios de ejemplo para 2 estilistas con IDs ficticios
enum StylistScheduleExamples {
    static let schedules: [StylistSchedule] = [
        StylistSchedule(
            stylistID: "stylist1",
            weeklySchedule: [
                "Monday": ["start": "10:00", "end": "18:00"],
                "Tuesday": ["start": "12:00", "end": "20:00"],
                "Wednesday": ["start": "10:00", "end": "18:00"],
                "Thursday": ["start": "10:00", "end": "18:00"],
                "Friday": ["start": "12:00", "end": "20:00"],
                "Saturday": ["start": "10:00", "end": "14:00"],
                "Sunday": ["start": "", "end": ""]
            ]
        ),
        StylistSchedule(
            stylistID: "stylist2",
            weeklySchedule: [
                "Monday": ["start": "09:00", "end": "17:00"],
                "Tuesday": ["start": "09:00", "end": "17:00"],
                "Wednesday": ["start": "09:00", "end": "17:00"],
                "Thursday": ["start": "14:00", "end": "20:00"],
                "Friday": ["start": "14:00", "end": "20:00"],
                "Saturday": ["start": "", "end": ""],
                "Sunday": ["start": "", "end": ""]
            ]
        )
    ]
}

class StylistScheduleUploader {
    static func uploadExampleSchedulesIfNeeded() {
        let db = Firestore.firestore()
        for schedule in StylistScheduleExamples.schedules {
            let docRef = db.collection("stylists").document(schedule.stylistID)
            docRef.getDocument { snapshot, error in
                guard let snapshot = snapshot, error == nil else { return }
                if !snapshot.exists || snapshot.data()?["weeklySchedule"] == nil {
                    // Solo sube si no existe el horario
                    docRef.setData(["weeklySchedule": schedule.weeklySchedule], merge: true) { err in
                        if let err = err {
                            print("Error subiendo horario de ejemplo: \(err.localizedDescription)")
                        } else {
                            print("Horario de ejemplo subido para estilista \(schedule.stylistID)")
                        }
                    }
                } else {
                    print("El horario ya existe para estilista \(schedule.stylistID)")
                }
            }
        }
    }
}

// Usa StylistScheduleUploader.uploadExampleSchedulesIfNeeded()
// en tu AppDelegate, SceneDelegate o ContentView.onAppear para cargar los horarios al lanzar la app la primera vez.
