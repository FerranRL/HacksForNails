//
//  LoginViewModel.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 20/6/24.
//

import SwiftUI
import Firebase
import CryptoKit
import AuthenticationServices
import GoogleSignInSwift
import GoogleSignIn
import FirebaseFirestore
import FirebaseStorage

class LoginViewModel:ObservableObject {
    
    static let shared = LoginViewModel()
    
    @Published var logStatus: Bool = false
        @Published var currentUser: User? {
            didSet {
                if let user = currentUser {
                    saveUserToDefaults(user: user)
                } else {
                    removeUserFromDefaults()
                }
            }
        }
    
    func signOut() {
            do {
                try Auth.auth().signOut()
                self.currentUser = nil
                self.logStatus = false
                removeUserFromDefaults()
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        }

        
    func checkUserStatus() {
            isLoading = true
            // Verificar si hay un usuario autenticado en Firebase
            if let firebaseUser = Auth.auth().currentUser {
                fetchUserData(userIdentifier: firebaseUser.uid)
            } else if let savedUser = loadUserFromDefaults() {
                self.currentUser = savedUser
                self.loadUserData() // Cargar la imagen de perfil si es necesario
                self.logStatus = true
                self.isLoading = false
            } else {
                // No hay usuario autenticado
                self.logStatus = false
                self.currentUser = nil
                self.isLoading = false
            }
        }
        
    func fetchUserData(userIdentifier: String) {
            let userDocument = Firestore.firestore().collection("users").document(userIdentifier)
            
            userDocument.getDocument { [weak self] (document, error) in
                guard let self = self else { return }
                
                if let document = document, document.exists, let data = document.data() {
                    let user = User(
                        id: data["userID"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        fullName: data["fullname"] as? String ?? "",
                        role: data["role"] as? String ?? "",
                        phone: data["phoneNumber"] as? String ?? "",
                        profileImage: data["profilePhoto"] as? String ?? ""
                    )
                    self.currentUser = user
                    self.logStatus = true
                    
                    // Cargar la imagen de perfil
                    if let profilePhotoURL = user.profileImage {
                        self.loadImage(from: profilePhotoURL) { image in
                            DispatchQueue.main.async {
                                self.profileImage = image
                                self.isLoading = false // Finaliza la carga
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.isLoading = false // Finaliza la carga
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.logStatus = false
                        self.currentUser = nil
                        self.isLoading = false
                    }
                }
            }
        }
        
        private func saveUserToDefaults(user: User) {
            // Serializar el usuario y guardarlo en UserDefaults
            let userData: [String: Any] = [
                "id": user.id,
                "email": user.email,
                "fullName": user.fullName,
                "role": user.role,
                "phone": user.phone ?? "",
                "profileImage": user.profileImage ?? ""
            ]
            UserDefaults.standard.set(userData, forKey: "currentUser")
        }
        
        private func loadUserFromDefaults() -> User? {
            // Recuperar los datos del usuario de UserDefaults
            guard let userData = UserDefaults.standard.dictionary(forKey: "currentUser") else { return nil }
            let user = User(
                id: userData["id"] as? String ?? "",
                email: userData["email"] as? String ?? "",
                fullName: userData["fullName"] as? String ?? "",
                role: userData["role"] as? String ?? "",
                phone: userData["phone"] as? String ?? "",
                profileImage: userData["profileImage"] as? String ?? ""
            )
            return user
        }
        
        private func removeUserFromDefaults() {
            // Eliminar los datos del usuario de UserDefaults
            UserDefaults.standard.removeObject(forKey: "currentUser")
        }
    
    init() {
        checkUserStatus()
        checkAuthStatus()
        loadUserData()
    }
    
    // MARK: View properties
    @Published var mobileNo: String = ""
    @Published var otpCode: String = ""
    @Published var testingOTP: Bool = true
    
    @Published var CLIENT_CODE: String = ""
    @Published var showOTPField: Bool = false
    
    //MARK: Error properties
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    // MARK: App log status
    //@AppStorage("log_status") var logStatus: Bool = false
    
    
    // MARK: Apple Sign in Properties
    @Published var currentNonce: String?
    
    @Published var showPhoneNumberForm: Bool = false
    @Published var showAdditionalInfoForm: Bool = false
    
    //@Published var currentUser: User? = nil
    @Published var profileImage: UIImage? = nil
    @Published var isLoading: Bool = true
    @Published var backgroundImage: UIImage? = nil
    
    // MARK: Get User data
    func loadUserData() {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(userID)
            
            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let data = document.data() {
                        let fullName = data["fullname"] as? String ?? "Nombre"
                        let email = data["email"] as? String ?? "email@example.com"
                        let phone = data["phoneNumber"] as? String ?? "+34123456789"
                        let role = data["role"] as? String ?? "rol"
                        let profilePhotoURL = data["profilePhoto"] as? String
                        let backgroundPhotoURL = data["profilePhoto"] as? String
                        
                        self.currentUser = User(id: userID, email: email, fullName: fullName, role: role, phone: phone, profileImage: profilePhotoURL)
                        
                        if let profilePhotoURL = profilePhotoURL {
                            self.loadImage(from: profilePhotoURL) { image in
                                self.profileImage = image
                            }
                        }
                        
                        if let backgroundPhotoURL = backgroundPhotoURL {
                            self.loadImage(from: backgroundPhotoURL) { image in
                                self.backgroundImage = image
                            }
                        }
                    }
                } else {
                    
                }
            }
        }
        
        func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
            let storageRef = Storage.storage().reference(forURL: urlString)
            
            storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if error != nil {
                    
                    completion(nil)
                } else if let data = data {
                    let image = UIImage(data: data)
                    completion(image)
                }
            }
        }
    
    // MARK: Firebase API's
    
    func checkAuthStatus() {
            if let user = Auth.auth().currentUser {
                // Usuario autenticado
                //self.logStatus = true
                self.loadCurrentUser(userID: user.uid) { success in
                    if !success {
                        
                    }
                }
            } else {
                // Usuario no autenticado
                DispatchQueue.main.async {
                                self.logStatus = false
                                self.currentUser = nil
                            }
            }
        }
    
    func getOTPCode() {
#if canImport(UIKit)
        UIApplication.shared.closeKeyboard()
#endif
        Task {
            do {
                // MARK: Disable it when testing with real device
                Auth.auth().settings?.isAppVerificationDisabledForTesting = testingOTP
                
                let code = try await PhoneAuthProvider.provider().verifyPhoneNumber("+\(mobileNo)", uiDelegate: nil)
                await MainActor.run(body: {
                    CLIENT_CODE = code
                    
                    // MARK: Enabling OTP field when it's success
                    withAnimation(.easeInOut) { showOTPField = true }
                })
            } catch {
                await handleError(error: error)
            }
        }
    }
    
    func verifyOTPCode() {
        UIApplication.shared.closeKeyboard()
        Task {
            do {
                // Obtener credenciales y autenticar al usuario
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: CLIENT_CODE, verificationCode: otpCode)
                let authResult = try await Auth.auth().signIn(with: credential)
                let firebaseUser = authResult.user
                let userIdentifier = firebaseUser.uid
                let userDocument = Firestore.firestore().collection("users").document(userIdentifier)
                
                // Obtener el documento de usuario usando async/await
                let documentSnapshot = try await userDocument.getDocument()
                
                if documentSnapshot.exists {
                    // Cargar los datos del usuario existente
                    if let data = documentSnapshot.data(),
                       let email = data["email"] as? String,
                       let fullName = data["fullname"] as? String,
                       let role = data["role"] as? String,
                       let phone = data["phoneNumber"] as? String,
                       let userImage = data["profilePhoto"] as? String {
                        // Actualizar el usuario actual
                        DispatchQueue.main.async {
                            self.currentUser = User(id: userIdentifier, email: email, fullName: fullName, role: role, phone: phone, profileImage: userImage)
                        }
                       
                    }
                } else {
                    // Crear nuevos datos del usuario
                    let userData: [String: Any] = [
                        "userID": userIdentifier,
                        "phoneNumber": self.mobileNo,
                        "role": "client"
                    ]
                    // Guardar los nuevos datos del usuario en Firestore
                    try await userDocument.setData(userData, merge: true)
                    
                    // Mostrar formulario adicional
                    self.showAdditionalInfoForm = true
                    
                    // Crear el objeto User
                    self.currentUser = User(id: userIdentifier, email: "", fullName: "", role: "client", phone: self.mobileNo, profileImage: "")
                }
                
                // Actualizar el estado de inicio de sesión en la interfaz de usuario
                DispatchQueue.main.async {
                    withAnimation(.easeInOut) {
                        self.logStatus = true
                    }
                }
                
            } catch {
                // Manejo de errores
                await handleError(error: error)
            }
        }
    }
    
    // MARK: Handling error
    func handleError(error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
    
    func showError(_ message: String) {
        errorMessage = message
        showError.toggle()
    }
    
    func handleSignInButton() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let signInResult = signInResult else {
                self.errorMessage = "Sign-In result is nil"
                return
            }
            
            let idToken = signInResult.user.idToken!.tokenString
            let accessToken = signInResult.user.accessToken.tokenString
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            self.logGoogleUser(with: credential, user: signInResult.user)
        }
    }
    
    func logGoogleUser(with credential: AuthCredential, user: GIDGoogleUser) {
        Task {
            do {
                let authResult = try await Auth.auth().signIn(with: credential)
                let firebaseUser = authResult.user
                let userIdentifier = firebaseUser.uid
                let email = user.profile?.email
                let fullName = user.profile?.name
                let userDocument = Firestore.firestore().collection("users").document(userIdentifier)

                // Obtener el documento de usuario usando async/await
                let documentSnapshot = try await userDocument.getDocument()
                
                if documentSnapshot.exists {
                    // Cargar los datos del usuario existente
                    if let data = documentSnapshot.data() {
                        let email = data["email"] as? String ?? ""
                        let fullName = data["fullname"] as? String ?? ""
                        let role = data["role"] as? String ?? ""
                        let phone = data["phoneNumber"] as? String ?? ""
                        let userImage = data["profilePhoto"] as? String
                        
                        DispatchQueue.main.async {
                            self.currentUser = User(id: userIdentifier, email: email, fullName: fullName, role: role, phone: phone, profileImage: userImage)
                            
                            withAnimation(.easeInOut) {
                                self.logStatus = true
                            }
                        }
                        
                    }
                } else {
                    // Si el documento no existe, crearlo con los datos disponibles
                    var userData: [String: Any] = ["userID": userIdentifier]
                    if let email = email {
                        userData["email"] = email
                    }
                    if let fullName = fullName {
                        userData["fullname"] = fullName
                    }
                    userData["role"] = "client"
                    
                    // Guardar los nuevos datos del usuario en Firestore
                    try await userDocument.setData(userData, merge: true)
                    
                    // Mostrar formulario de número de teléfono y crear objeto User
                    self.showPhoneNumberForm = true
                    self.currentUser = User(id: userIdentifier, email: email ?? "", fullName: fullName ?? "", role: "client", phone: "", profileImage: "")
                    
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut) {
                            self.logStatus = true
                        }
                    }
                }
                
            } catch {
                // Manejo de errores
                await handleError(error: error)
            }
        }
    }
    func loginWithFirebase(_ authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let nonce = currentNonce else {
                showError("Cannot process your request.")
                
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                showError("Unable to fetch identity token")
                
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                showError("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                
                return
            }
            
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    self.showError(error.localizedDescription)
                    return
                }
                
                guard let user = authResult?.user else {
                    self.showError("DEBUG: No se puede recuperar el usuario")
                    return
                }
                
                let userIdentifier = user.uid
                let email = appleIDCredential.email
                let fullName = appleIDCredential.fullName
                
                let userDocument = Firestore.firestore().collection("users").document(userIdentifier)
                
                userDocument.getDocument { (document, error) in
                    if let document = document, document.exists {
                        
                        self.fetchUserData(userIdentifier: userIdentifier)
                        self.logStatus = true
                    } else {
                        var userData: [String: Any] = ["userID": userIdentifier]
                        if let email = email {
                            userData["email"] = email
                        }
                        if let fullName = fullName {
                            userData["fullname"] = "\(fullName.givenName ?? "") \(fullName.familyName ?? "")"
                        }
                        userData["role"] = "client"
                        
                        userDocument.setData(userData, merge: true) { (error) in
                            if let error = error {
                                self.showError("DEBUG: Error writing user data to Firestore: \(error.localizedDescription)")
                            } else {
                                
                                self.showPhoneNumberForm = true
                                self.logStatus = true
                            }
                        }
                    }
                }
                
                
            }
        }
    }
    
    func loadCurrentUser(userID: String, completion: @escaping (Bool) -> Void) {
        let userDocument = Firestore.firestore().collection("users").document(userID)
        
        userDocument.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data(),
                   let email = data["email"] as? String,
                   let fullName = data["fullname"] as? String,
                   let role = data["role"] as? String,
                   let phone = data["phoneNumber"] as? String,
                   let userImage = data["profilePhoto"] as? String
                {
                    self.currentUser = User(id: userID, email: email, fullName: fullName, role: role, phone: phone, profileImage: userImage)
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    func logout() {
            do {
                self.logStatus = false
                // 1. Desconectar de Firebase
                try Auth.auth().signOut()
                
                // 2. Desconectar de Google
                GIDSignIn.sharedInstance.signOut()
                
                // 3. Actualizar el estado en el hilo principal
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.currentUser = nil
                    self.mobileNo = ""
                    self.otpCode = ""
                    self.CLIENT_CODE = ""
                    self.showOTPField = false
                    self.profileImage = nil
                    self.backgroundImage = nil
                    
                    // 4. Verificar el estado después del logout
                    self.checkAuthStatus()
                    
                }
            } catch let signOutError as NSError {
                self.showError("DEBUG: Error al hacer logout:\(signOutError)")
            }
        }
}

