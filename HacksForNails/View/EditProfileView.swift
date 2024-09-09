//
//  EditProfileView.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 9/7/24.
//

import SwiftUI

struct EditProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var loginModel: LoginViewModel = LoginViewModel.shared
    @State var currentUser = LoginViewModel.shared.currentUser
    @FocusState private var focusedField: FocusedField?
    @State var username: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Image("bg2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                
                VStack {
                    HStack(alignment: .center) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.backward.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        }
                        .padding()
                        
                        Text("Edita tu perfil")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .bold()
                        Spacer()
                    }
                    VStack {
                        ZStack {
                            if let pImage = loginModel.profileImage {
                                Image(uiImage: pImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 180, height: 180)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    .shadow(radius: 10)
                            } else {
                                Image("bg2")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 180, height: 180)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    .shadow(radius: 10)
                            }
                            
                            Button {
                                print("DEBUG: Load Image")
                            } label: {
                                Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.camera.fill")
                                    .font(.system(size: 50))
                                    .foregroundStyle(.white)
                            }

                        }
                    }
                    .padding(.vertical, 50)
                    VStack(spacing: 20) {
                        HStack(alignment: .center ,spacing: 25) {
                            CustomTextField(hint: currentUser?.fullName ?? "Nombre", hintColor: .white, text: $username, focusedField: $focusedField, currentField: .field1)
                            Spacer()
                            
                        }
                        HStack(alignment: .center ,spacing: 20) {
                            
                            
                            CustomTextField(hint: currentUser?.email ?? "example@gmail.com", hintColor: .white, text: $email, focusedField: $focusedField, currentField: .field2)
                            Spacer()
                            
                        }
                        HStack(alignment: .center ,spacing: 20) {
                            
                            CustomTextField(hint: currentUser?.phone ?? "+34628302186", hintColor: .white, text: $phone, focusedField: $focusedField, currentField: .field3)
                                
                            Spacer()
                            
                        }
                    }
                    .foregroundStyle(.white)
                    
                }
                .padding(.top, 50)
                
                .foregroundStyle(.white)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    EditProfileView()
}
