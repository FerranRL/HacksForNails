//
//  ContentView.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 17/6/24.
//

import SwiftUI
//import StylistScheduleUploader

struct ContentView: View {
    @StateObject var loginModel: LoginViewModel = LoginViewModel.shared

    var body: some View {
        NavigationStack {
            if loginModel.isLoading {
                // Vista de carga mientras se cargan los datos del usuario
                LoadingView()
            } else if loginModel.logStatus {
                if let currentUser = loginModel.currentUser {
                    if currentUser.role == "admin" {
                        DashboardView()
                            .environmentObject(loginModel)
                    } else if currentUser.role == "stylist" {
                        StylistView()
                            .environmentObject(loginModel)
                    } else {
                        Home(user: currentUser) // Pantalla para usuarios regulares
                    }
                }
            } else {
                Login() // Pantalla de inicio de sesión
            }
        }
        .onAppear {
            // Verificar el estado del usuario al iniciar la aplicación
            loginModel.checkUserStatus()
            StylistScheduleUploader.uploadExampleSchedulesIfNeeded()
            //loginModel.logout()
        }
    }
}




#Preview {
    ContentView()
}

