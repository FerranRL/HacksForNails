//
//  DataRequestView.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 6/7/24.
//

import SwiftUI
import Firebase

struct DataRequestView: View {
    @State private var fullName: String = ""
        @State private var email: String = ""
        @State private var isSubmitting: Bool = false
    
    @Environment(\.dismiss) var dismiss
        
        var body: some View {
            NavigationView {
                VStack {
                    TextField("Full Name", text: $fullName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: submit) {
                        if isSubmitting {
                            ProgressView()
                        } else {
                            Text("Submit")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .disabled(isSubmitting)
                }
                .padding()
                .navigationTitle("Complete your profile")
            }
        }
        
        func submit() {
            isSubmitting = true
            
            guard let userID = Auth.auth().currentUser?.uid else {
                isSubmitting = false
                return
            }
            
            let userDocument = Firestore.firestore().collection("users").document(userID)
            
            var userData: [String: Any] = [:]
            if !fullName.isEmpty {
                userData["fullname"] = fullName
            }
            if !email.isEmpty {
                userData["email"] = email
            }
            
            userDocument.updateData(userData) { error in
                if let error = error {
                    print("DEBUG: Error updating user data: \(error.localizedDescription)")
                } else {
                    print("DEBUG: User data successfully updated")
                }
                isSubmitting = false
                dismiss()
            }
        }
}

#Preview {
    DataRequestView()
}
