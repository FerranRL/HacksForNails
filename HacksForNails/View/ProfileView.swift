//
//  ProfileView.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 5/7/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import PhotosUI
import PassKit

struct ProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var loginModel: LoginViewModel = LoginViewModel.shared
    @State var currentUser = LoginViewModel.shared.currentUser
    @State var profileImage: UIImage? = nil
    @State var backgroundImage: UIImage? = nil
    @State var showImagePicker = false
    @State var selectedImageData: Data? = nil
    @State var editProfile: Bool = false
    @FocusState private var focusedField: FocusedField?
    @State var username: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                if let bgImage = loginModel.backgroundImage {
                    Image(uiImage: bgImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .blur(radius: editProfile ? 20 : 0, opaque: editProfile ?  true : false )
                } else {
                    Image("bg2")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
                
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
                        Button(action: {
                            withAnimation(.easeInOut) {
                                editProfile.toggle()
                            }
                            
                            
                        }) {
                            Image(systemName: editProfile ? "checkmark.circle.fill" : "pencil")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        }
                        .padding()
                        .sheet(isPresented: $showImagePicker, onDismiss: uploadImage) {
                            ImagePicker(selectedImageData: $selectedImageData)
                        }
                        Button(action: {createAndAddWalletPass(stamps: 5, nextAppointment: "15 Septiembre 2024")}) {
                            HStack {
                                Image(systemName: "wallet.pass")
                                    .font(.title2)
                                Text("Añadir a Wallet")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }
                    .padding(.top, 50)
                    if !editProfile {
                        Spacer()
                    }
                        
                    
                    
                    VStack(alignment: .leading) {
                        
                        if editProfile {
                            
                            HStack(spacing: 15) {
                                
                                ZStack {
                                    if let pImage = loginModel.profileImage {
                                        Image(uiImage: pImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                            .shadow(radius: 10)
                                    } else {
                                        Image("bg2")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                            .shadow(radius: 10)
                                    }
                                    
                                    Button {
                                        showImagePicker = true
                                    } label: {
                                        Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.camera.fill")
                                            .font(.system(size: 30))
                                            .foregroundStyle(.white)
                                    }
                                }
                                
                                VStack(alignment: .leading) {
                                    CustomTextField(hint: currentUser?.fullName ?? "Nombre", hintColor: .white, text: $username, focusedField: $focusedField, currentField: .field1)
                                    
                                    CustomTextField(hint: currentUser?.email ?? "example@gmail.com", hintColor: .white, text: $email, focusedField: $focusedField, currentField: .field2)
                                    
                                    CustomTextField(hint: currentUser?.phone ?? "+34628302186", hintColor: .white, text: $phone, focusedField: $focusedField, currentField: .field3)
                                }
                                .onAppear {
                                    username = currentUser?.fullName ?? "Nombre"
                                    email = currentUser?.email ?? "Email"
                                    phone = currentUser?.phone ?? "Teléfono"
                                    
                                    
                                }
                            }
                            
                        } else {
                            HStack(spacing: 15) {
                                
                                if let pImage = loginModel.profileImage {
                                    Image(uiImage: pImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                        .shadow(radius: 10)
                                } else {
                                    Image("bg2")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                        .shadow(radius: 10)
                                }
                                VStack(alignment: .leading) {
                                    Text(currentUser?.fullName ?? "Nombre")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Text(currentUser?.email ?? "test@gmail.com")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text(currentUser?.phone ?? "+34123456789")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        
                        
                        HStack(alignment: .center, spacing: 20) {
                            Spacer(minLength: 0)
                            VStack {
                                Text("5")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("Citas pasadas")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            VStack {
                                Text("1")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("Próximas citas")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            VStack {
                                Text("6")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("Citas totales")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(.vertical, 10)
                        
                        Text("Dispones de 5 sellos para conseguir un descuento de un 40%.")
                            .font(.callout)
                            .foregroundColor(.white)
                        
                        Text("Consigue 3 sellos más y te aplicaremos el descuento al siguiente servicio.")
                            .font(.callout)
                            .foregroundColor(.white)
                        
                        HStack {
                            Text("Ver sellos y condiciones de la promoción")
                                .font(.caption)
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                    .background(Color.black)
                    .cornerRadius(15)
                    .padding(.top, 20)
                    .padding(.bottom)
                    
                    if editProfile {
                        Spacer()
                    }
                    
                }
                .padding()
                
                Spacer()
            }
            
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)

    }
    
    // Función para crear el archivo pass.json
    func createPassJSON(stamps: Int, nextAppointment: String) -> Data? {
        let passData: [String: Any] = [
            "formatVersion": 1,
            "passTypeIdentifier": "com.paretsdesign.hacksfornails",
            "serialNumber": "1234567890",
            "teamIdentifier": "H86KV5J4UN",
            "barcode": [
              "message": "1234567890",
              "format": "PKBarcodeFormatQR",
              "messageEncoding": "iso-8859-1"
            ],
            "organizationName": "Beauty Hacks",
            "description": "Tarjeta Cliente",
            "logoText": "H A C K S",
            "foregroundColor": "rgb(255, 255, 255)",
            "backgroundColor": "rgb(0, 0, 0)",
            "generic": [
                "primaryFields": [
                    [
                        "key": "stamps",
                        "label": "Sellos Acumulados",
                        "value": "\(stamps)"
                    ]
                ],
                "secondaryFields": [
                    [
                        "key": "nextAppointment",
                        "label": "Próxima Cita",
                        "value": nextAppointment
                    ]
                ]
            ]
        ]
        
        // Convierte el diccionario en JSON data
        return try? JSONSerialization.data(withJSONObject: passData, options: [])
    }

    // Función para cargar imágenes desde los recursos de la app
    func loadImageData(imageName: String) -> Data? {
        guard let image = UIImage(named: imageName), let imageData = image.pngData() else {
            return nil
        }
        return imageData
    }

    // Función para generar el hash SHA-1 de los archivos
    func sha1Hash(data: Data) -> String {
        // Generar el hash SHA-1 para el manifest.json
        // Implementa la generación del hash utilizando una librería de hash, aquí se muestra como un placeholder
        return data.base64EncodedString() // Placeholder
    }

    // Función para enviar el manifest al servidor y recibir la firma
    func signManifestOnServer(manifestData: Data, completion: @escaping (Data?) -> Void) {
        // Aquí debes implementar la lógica para enviar el manifestData al servidor y recibir la firma
        // Este es un placeholder que simula la llamada
        completion(Data()) // Reemplaza esto con la respuesta del servidor
    }

    // Función para crear el archivo .pkpass
    func createPassPackage(passJSON: Data, manifestData: Data, signature: Data, images: [String: Data]) -> Data {
        var passFiles: [String: Data] = [
            "pass.json": passJSON,
            "manifest.json": manifestData,
            "signature": signature
        ]
        
        for (fileName, data) in images {
            passFiles[fileName] = data
        }
        
        // Empaquetar todos los archivos en un archivo .pkpass usando zip
        // Implementa la creación del archivo .pkpass con las librerías de compresión disponibles
        return Data() // Placeholder
    }

    // Función para presentar el pase en Wallet
    func presentPassToWallet(passPackage: Data) {
        do {
            let pass = try PKPass(data: passPackage)
            let addPassesViewController = PKAddPassesViewController(pass: pass)
            
            // Presentar el controlador de agregar pase
            if let addPassesViewController = addPassesViewController {
                UIApplication.shared.windows.first?.rootViewController?.present(addPassesViewController, animated: true, completion: nil)
            }
        } catch {
            print("Error al presentar el pase: \(error.localizedDescription)")
        }
    }
}
    
    func uploadImage() {
        guard let imageData = selectedImageData, let userID = currentUser?.id else { return }
        
        let storageRef = Storage.storage().reference().child("profilePhotos/\(userID).jpg")
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                loginModel.showError("DEBUG: Error al subir la imagen: \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    loginModel.showError("DEBUG: Error al obtener la URL de la imagen: \(error.localizedDescription)")
                    return
                }
                
                guard let url = url else { return }
                
                let db = Firestore.firestore()
                db.collection("users").document(userID).updateData(["profilePhoto": url.absoluteString]) { error in
                    if let error = error {
                        loginModel.showError("DEBUG: Error al actualizar la referencia de la imagen en Firestore: \(error.localizedDescription)")
                    } else {
                        loginModel.loadUserData()
                    }
                }
            }
        }
        
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImageData: Data?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImageData = image.jpegData(compressionQuality: 0.8)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

#Preview {
    ProfileView()
}
