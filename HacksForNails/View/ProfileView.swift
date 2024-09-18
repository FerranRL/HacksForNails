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
import Zip
import CommonCrypto

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
                                Image(systemName: "wallet.pass.fill")
                                    .font(.title2)
                            }
                            .foregroundColor(.white)
                            .padding()
                        }
                    }
                    .padding(.top, 40)
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
    
    func createAndAddWalletPass(stamps: Int, nextAppointment: String) {
        // 1. Crear pass.json dinámicamente
        guard let passJSON = createPassJSON(stamps: stamps, nextAppointment: nextAppointment) else {
            print("Error al crear pass.json")
            return
        }

        // 2. Cargar imágenes necesarias
        guard let iconData = loadImageData(imageName: "icon3"), // Cambia "icon" por el nombre correcto de tu imagen
              let logoData = loadImageData(imageName: "logo black") else { // Cambia "logo" por el nombre correcto de tu imagen
            print("Error al cargar imágenes")
            return
        }

        // 3. Crear el manifest con los hashes de los archivos
        let manifest = [
            "pass.json": sha1Hash(data: passJSON),
            "icon.png": sha1Hash(data: iconData),
            "logo.png": sha1Hash(data: logoData)
        ]
        
        // Verificar el contenido del manifest
        print("Manifest creado: \(manifest)")

        guard let manifestData = try? JSONSerialization.data(withJSONObject: manifest, options: []) else {
            print("Error al crear manifest.json")
            return
        }
        
        // Verificar los datos del manifest antes de enviarlos
        print("Manifest Data: \(String(data: manifestData, encoding: .utf8) ?? "Error al mostrar manifest data")")

        // 4. Enviar manifest al servidor para firmar y obtener la signature
        signManifestOnServer(manifestData: manifestData) { signature in
            guard let signature = signature else {
                print("Error al firmar el manifest en el servidor")
                return
            }
            
            // 5. Crear y empaquetar el archivo .pkpass
            let passPackage = createPassPackage(passJSON: passJSON, manifestData: manifestData, signature: signature, images: ["icon.png": iconData, "logo.png": logoData])
            
            // Verificar que el pase se ha creado correctamente
            if passPackage == nil {
                print("Error al crear el archivo .pkpass")
                return
            }
            
            // 6. Presentar el pase en Wallet
            presentPassToWallet(passPackage: passPackage)
        }
    }
    
    // Función para crear el archivo pass.json
    func createPassJSON(stamps: Int, nextAppointment: String) -> Data? {
        let passData: [String: Any] = [
            "formatVersion": 1,
              "passTypeIdentifier": "pass.com.paretsdesign.hacksfornails", // Asegúrate de que coincide exactamente con tu certificado
              "serialNumber": "1234567890",
              "teamIdentifier": "H86KV5J4UN", // Asegúrate de que coincide exactamente con tu equipo
              "organizationName": "Beauty Hacks",
              "description": "Tarjeta Cliente",
              "logoText": "H A C K S",
              "foregroundColor": "rgb(255, 255, 255)",
              "backgroundColor": "rgb(0, 0, 0)",
            "barcode": [
                "message": "1234567890",
                "format": "PKBarcodeFormatQR",
                "messageEncoding": "iso-8859-1"
            ],
            "generic": [
                    "headerFields": [
                        [
                            "key": "header",
                            "label": "Beauty Hacks",
                            "value": ""
                        ]
                    ],
                    "primaryFields": [
                        [
                            "key": "stamps",
                            "label": "",
                            "value": "Tienes \(stamps) sellos. Consigue 3 sellos más para obtener un descuento."
                        ]
                    ],
                    "secondaryFields": [
                        [
                            "key": "nextAppointment",
                            "label": "Próxima Cita",
                            "value": "\(nextAppointment)"
                        ]
                    ]
                ]
        ]
        
        // Convierte el diccionario en JSON data
        return try? JSONSerialization.data(withJSONObject: passData, options: [])
    }

    // Función para cargar imágenes desde los recursos de la app
    func loadImageData(imageName: String) -> Data? {
        guard let image = UIImage(named: imageName) else {
            print("Error: No se pudo encontrar la imagen \(imageName)")
            return nil
        }
        guard let imageData = image.pngData() else {
            print("Error: No se pudo convertir la imagen \(imageName) a PNG")
            return nil
        }
        print("Imagen \(imageName) cargada correctamente")
        return imageData
    }

    // Función para generar el hash SHA-1 de los archivos
    func sha1Hash(data: Data) -> String {
        // Array para almacenar el hash SHA-1 (20 bytes)
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        
        // Calcular el hash SHA-1
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &hash)
        }
        
        // Convertir el hash en una cadena hexadecimal
        return hash.map { String(format: "%02x", $0) }.joined()
    }

    // Función para enviar el manifest al servidor y recibir la firma
    func signManifestOnServer(manifestData: Data, completion: @escaping (Data?) -> Void) {
        print("Enviando manifest al servidor...")
        let url = URL(string: "https://pass-signing-vercel.vercel.app/api/sign")! // Asegúrate de que esta URL es correcta
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Configura la solicitud para enviar el archivo manifest como multipart/form-data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"manifest\"; filename=\"manifest.json\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
        body.append(manifestData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Realiza la solicitud al servidor Vercel
        URLSession.shared.uploadTask(with: request, from: body) { data, response, error in
            if let error = error {
                print("Error al enviar el manifest: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Imprimir la respuesta HTTP
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de respuesta del servidor: \(httpResponse.statusCode)")
                print("Headers de respuesta: \(httpResponse.allHeaderFields)")
            }
            
            // Verificar los datos recibidos
            if let data = data {
                print("Datos recibidos del servidor: \(data)")
                // Si quieres ver el contenido en formato hexadecimal
                print("Firma recibida en hexadecimal: \(data.map { String(format: "%02x", $0) }.joined())")
            } else {
                print("No se recibieron datos del servidor.")
            }
            
            // Devuelve la firma recibida del servidor
            completion(data)
        }.resume()
    }

    // Función para crear el archivo .pkpass
    func createPassPackage(passJSON: Data, manifestData: Data, signature: Data, images: [String: Data]) -> Data? {
        // Crear un directorio temporal para almacenar los archivos del pase
        let fileManager = FileManager.default
        let tempDirectoryURL = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        do {
            // Crear la carpeta temporal
            try fileManager.createDirectory(at: tempDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            
            // Guardar pass.json
            let passJSONURL = tempDirectoryURL.appendingPathComponent("pass.json")
            try passJSON.write(to: passJSONURL)
            
            // Guardar manifest.json
            let manifestURL = tempDirectoryURL.appendingPathComponent("manifest.json")
            try manifestData.write(to: manifestURL)
            
            // Guardar la signature
            let signatureURL = tempDirectoryURL.appendingPathComponent("signature")
            try signature.write(to: signatureURL)
            
            // Guardar las imágenes
            for (fileName, imageData) in images {
                let imageURL = tempDirectoryURL.appendingPathComponent(fileName)
                try imageData.write(to: imageURL)
            }
            
            // Comprimir todos los archivos en un .pkpass
            let passZipURL = tempDirectoryURL.appendingPathComponent("pass.pkpass")
            try Zip.zipFiles(paths: [passJSONURL, manifestURL, signatureURL] + images.map { tempDirectoryURL.appendingPathComponent($0.key) }, zipFilePath: passZipURL, password: nil, progress: nil)
            
            // Leer el archivo .pkpass generado
            let passData = try Data(contentsOf: passZipURL)
            return passData
            
        } catch {
            print("Error al crear el pase: \(error.localizedDescription)")
            return nil
        }
    }

    // Función para presentar el pase en Wallet
    func presentPassToWallet(passPackage: Data?) {
        guard let passPackage = passPackage else {
            print("Error: No se ha podido crear el archivo .pkpass")
            return
        }
        
        // Guardar el pase para análisis
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let passURL = documentsURL.appendingPathComponent("testPass.pkpass")
        
        do {
            try passPackage.write(to: passURL)
            print("Pase guardado en: \(passURL.path)")
        } catch {
            print("Error al guardar el pase: \(error.localizedDescription)")
        }
        
        // Presentar el pase en Wallet
        do {
            let pass = try PKPass(data: passPackage)
            let addPassesViewController = PKAddPassesViewController(pass: pass)
            
            if let addPassesViewController = addPassesViewController {
                UIApplication.shared.windows.first?.rootViewController?.present(addPassesViewController, animated: true, completion: nil)
            } else {
                print("Error: No se pudo crear el PKAddPassesViewController.")
            }
            
        } catch {
            print("Error al presentar el pase: \(error.localizedDescription)")
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
