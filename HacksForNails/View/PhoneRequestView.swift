//
//  PhoneRequestView.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 6/7/24.
//

import SwiftUI
import Firebase

struct PhoneRequestView: View {
    @State private var phoneNumber: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Enter your phone number")
                .font(.title)
                .padding()
            
            TextField("Phone Number", text: $phoneNumber)
                .keyboardType(.phonePad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            
            Button(action: savePhoneNumber) {
                Text("Save")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
    
    func savePhoneNumber() {
        // Save the phone number to Firestore
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let userDocument = Firestore.firestore().collection("users").document(userID)
        userDocument.updateData([
            "phoneNumber": phoneNumber
        ]) { error in
            if let error = error {
                print("DEBUG: Error updating phone number: \(error.localizedDescription)")
            } else {
                dismiss()
            }
        }
    }
}

#Preview {
    PhoneRequestView()
}
