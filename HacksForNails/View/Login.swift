import SwiftUI
import CryptoKit
import AuthenticationServices
import GoogleSignIn
import GoogleSignInSwift
import FirebaseFirestore
import Firebase

struct Login: View {
    
    @StateObject var loginModel: LoginViewModel = LoginViewModel.shared
    @StateObject var variables: Variables = .init()
    @State var otpVisibility: Bool = false
    @State var showMenu: Bool = false
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isLoading: Bool = false
    @State private var nonce: String?
    @FocusState private var focusedField: FocusedField?
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    @State private var navigateToHome = false
    @State private var isLoadingInitialData = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    if loginModel.logStatus {
                        
                        if let currentUser = loginModel.currentUser {
                            
                            Home(user: currentUser)
                        }
                            
                            
                    } else {
                            Image("bg2")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .opacity(0.5)
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack {
                                    HStack {
                                        
                                        Spacer()
                                        
                                        Button {
                                            loginModel.testingOTP.toggle()
                                    } label: {
                                        Image(systemName: "phone.bubble.fill")
                                            .foregroundStyle(.black)
                                            .padding(8)
                                    }
                                    .background(loginModel.testingOTP ? .white : .white.opacity(0.5))
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                }
                                .padding(.top, 60)
                                .padding(.horizontal)
                                
                                VStack(alignment: .center, spacing: 15) {
                                    Image(.logoBlack)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 200, height: 200)
                                        .clipShape(Circle())
                                    Text("Bienvenid@")
                                        .font(.system(size: 35))
                                        .foregroundStyle(.white)
                                        .fontWeight(.light)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                    
                                    CustomTextField(hint: "Introduce tu teléfono", text: $loginModel.mobileNo, contentType: .telephoneNumber, focusedField: $focusedField, currentField: .field1)
                                        .disabled(loginModel.showOTPField)
                                        .opacity(loginModel.showOTPField ? 0.4 : 1)
                                        .overlay(alignment: .trailing) {
                                            Button("Cambiar número") {
                                                withAnimation(.easeInOut) {
                                                    loginModel.showOTPField = false
                                                    loginModel.otpCode = ""
                                                    loginModel.CLIENT_CODE = ""
                                                }
                                            }
                                            .font(.caption)
                                            .foregroundStyle(.white)
                                            .opacity(loginModel.showOTPField ? 1 : 0)
                                            .padding(.trailing, 15)
                                        }
                                        .padding(.top, 50)
                                    
                                    CustomTextField(hint: "Introduce el código que has recibido", text: $loginModel.otpCode, contentType: .telephoneNumber, focusedField: $focusedField, currentField: .field2)
                                        .disabled(!loginModel.showOTPField)
                                        .opacity(!loginModel.showOTPField ? 0 : 1)
                                        .padding(.top, 30)
                                    
                                    HStack {
                                        Button {
                                            if !loginModel.mobileNo.hasPrefix("34") {
                                                loginModel.mobileNo = "34" + loginModel.mobileNo
                                            }
                                            loginModel.showOTPField ? loginModel.verifyOTPCode() : loginModel.getOTPCode()
                                        } label: {
                                            HStack(spacing: 15) {
                                                Text(loginModel.showOTPField ? "Verificar Código" : "Obtener código")
                                                    .fontWeight(.semibold)
                                                    .contentTransition(.identity)
                                                
                                                Image(systemName: "line.diagonal.arrow")
                                                    .font(.title3)
                                                    .rotationEffect(.init(degrees: 45))
                                            }
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 25)
                                            .padding(.vertical)
                                            .background {
                                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                    .fill(.white.opacity(0.1))
                                            }
                                        }
                                        .padding(.top, 30)
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                }
                                
                                if variables.isLoginButtonsEnabled {
                                    Text("(O)")
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.top, 30)
                                        .padding(.bottom, 20)
                                        .padding(.horizontal)
                                    
                                    HStack(spacing: 8) {
                                        CustomButton()
                                            .overlay {
                                                SignInWithAppleButton(.signIn) { request in
                                                    let nonce = randomNonceString()
                                                    self.nonce = nonce
                                                    request.requestedScopes = [.email, .fullName]
                                                    request.nonce = sha256(nonce)
                                                } onCompletion: { result in
                                                    switch result {
                                                    case .success(let authorization):
                                                        loginWithFirebase(authorization)
                                                    case .failure(let error):
                                                        showError(error.localizedDescription)
                                                    }
                                                }
                                                .signInWithAppleButtonStyle(.white)
                                                .blendMode(.overlay)
                                            }
                                            .clipped()
                                        
                                        CustomButton(isGoogle: true)
                                            .overlay {
                                                GoogleSignInButton {
                                                    loginModel.handleSignInButton()
                                                }
                                                .blendMode(.overlay)
                                                
                                            }
                                            .clipped()
                                    }
                                    .padding(.horizontal, 20)
                                    .contentShape(Rectangle())
                                }
                            }
                            .padding(.bottom, keyboardResponder.currentHeight)
                            .offset(y: keyboardResponder.currentHeight == 0 ? 0 : -keyboardResponder.currentHeight * 0.25)
                            .animation(.easeOut(duration: 0.16), value: keyboardResponder.currentHeight)
                        }
                        .alert(errorMessage, isPresented: $showAlert) {}
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .background(Color.black)
            
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $loginModel.showPhoneNumberForm) {
            PhoneRequestView()
                }
        .sheet(isPresented: $loginModel.showAdditionalInfoForm) {
            DataRequestView()
                }
    }
    
    
    
    
    
    func showError(_ message: String) {
        errorMessage = message
        showAlert.toggle()
        isLoading = false
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("DEBUG: Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func loginWithFirebase(_ authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            showError("Failed to retrieve credentials.")
            return
        }

        isLoading = true
        guard let nonce else {
            showError("Cannot process your request.")
            isLoading = false
            return
        }
        
        guard let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            showError("Unable to fetch identity token")
            isLoading = false
            return
        }
        
        let credential = OAuthProvider.appleCredential(
            withIDToken: idTokenString,
            rawNonce: nonce,
            fullName: appleIDCredential.fullName
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            
            
            if let error = error {
                self.showError("Error during sign in: \(error.localizedDescription)")
                self.isLoading = false
                return
            }
            
            guard let user = authResult?.user else {
                self.showError("Failed to retrieve the authenticated user.")
                self.isLoading = false
                return
            }
            
            let userIdentifier = user.uid
            let userDocument = Firestore.firestore().collection("users").document(userIdentifier)
            
            userDocument.getDocument { (document, error) in
                
                
                if let document = document, document.exists, let data = document.data() {
                    // Configuración del usuario existente
                    self.loginModel.currentUser = User(
                        id: data["userID"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        fullName: data["fullname"] as? String ?? "",
                        role: data["role"] as? String ?? "",
                        phone: data["phoneNumber"] as? String ?? "",
                        profileImage: data["profilePhoto"] as? String ?? ""
                    )
                    
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut) {
                            self.loginModel.logStatus = true
                            self.isLoading = false
                        }
                    }
                    
                } else {
                    // Crear y guardar los datos del nuevo usuario
                    var userData: [String: Any] = ["userID": userIdentifier]
                    if let email = appleIDCredential.email {
                        userData["email"] = email
                    }
                    if let fullName = appleIDCredential.fullName {
                        userData["fullname"] = "\(fullName.givenName ?? "") \(fullName.familyName ?? "")"
                    }
                    userData["role"] = "client"
                    
                    userDocument.setData(userData, merge: true) { error in
                        if let error = error {
                            self.showError("Failed to write user data to Firestore: \(error.localizedDescription)")
                            self.isLoading = false
                        } else {
                            // Configuración del currentUser para el nuevo usuario
                            self.loginModel.currentUser = User(
                                id: userIdentifier,
                                email: appleIDCredential.email ?? "",
                                fullName: "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")",
                                role: "client",
                                phone: "", // Valor por defecto si no se proporciona un número de teléfono
                                profileImage: "" // Valor por defecto si no hay una imagen de perfil disponible
                            )
                            
                            DispatchQueue.main.async {
                                withAnimation(.easeInOut) {
                                    self.loginModel.logStatus = true
                                    self.isLoading = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fetchUserData(userIdentifier: String) {
        let userDocument = Firestore.firestore().collection("users").document(userIdentifier)
        
        userDocument.getDocument { (document, error) in
            if let document = document, document.exists, let data = document.data() {
                loginModel.currentUser = User(
                    id: data["userID"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    fullName: data["fullname"] as? String ?? "",
                    role: data["role"] as? String ?? "",
                    phone: data["phoneNumber"] as? String ?? "",
                    profileImage: data["profilePhoto"] as? String ?? ""
                )
                
                DispatchQueue.main.async {
                    withAnimation(.easeInOut) {
                        
                        loginModel.logStatus = true
                    }
                }
            } else {
                self.showError("DEBUG: User document does not exist.")
            }
        }
    }
    
    @ViewBuilder
    func CustomButton(isGoogle: Bool = false) -> some View {
        HStack {
            Group {
                if isGoogle {
                    Image("Google")
                        .resizable()
                        .renderingMode(.template)
                } else {
                    Image(systemName: "applelogo")
                        .resizable()
                }
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
            .frame(height: 45)
            
            Text("Entrar con \(isGoogle ? "Google" : "Apple")")
                .font(.callout)
                .lineLimit(1)
        }
        .foregroundStyle(.black)
        .padding(.horizontal, 8)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.white)
        }
    }
}

#Preview {
    ContentView()
}
