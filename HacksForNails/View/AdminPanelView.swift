//
//  AdminPanelView.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 5/9/24.
//

import SwiftUI
import FirebaseFirestore

struct AdminPanelView: View {
    @State private var showExcelPicker = false
    @StateObject var loginModel: LoginViewModel = LoginViewModel.shared
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Panel de Administración")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top, 40) // Espacio superior para el título
                
                Spacer()
                
                VStack(spacing: 20) {
                    Button(action: {
                        showExcelPicker.toggle()
                    }) {
                        HStack {
                            Text("Subir Servicios desde Excel")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                        }
                    }
                    .sheet(isPresented: $showExcelPicker) {
                        ExcelUploaderView { data in
                            // Procesa y sube los datos a Firebase
                            uploadDataToFirestore(data: data, collection: "services")
                        }
                    }
                    
                    Button(action: {
                        // Implementa funcionalidad similar para clientes
                    }) {
                        HStack {
                            Text("Subir Clientes desde Excel")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    // Llamar a la función de logout
                    loginModel.signOut()
                }) {
                    Text("Cerrar Sesión")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.ignoresSafeArea()) // Fondo negro ocupando toda la SafeArea
            .navigationBarHidden(true)
        }
    }
    
    func uploadDataToFirestore(data: [Dictionary<String, Any>], collection: String) {
        let db = Firestore.firestore()
        let ref = db.collection(collection)
        
        data.forEach { item in
            ref.addDocument(data: item) { error in
                if let error = error {
                    print("Error al subir los datos: \(error.localizedDescription)")
                } else {
                    print("Datos subidos correctamente")
                }
            }
        }
    }
}

#Preview {
    AdminPanelView()
}
