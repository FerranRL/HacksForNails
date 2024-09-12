//
//  StylistView.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 9/9/24.
//

import SwiftUI

struct StylistView: View {
    @EnvironmentObject var loginModel: LoginViewModel
    @State var currentUser = LoginViewModel.shared.currentUser
    @State private var showMenu: Bool = false
    @State private var selectedDate = Date()
    @State private var showingDatePicker = false

    var body: some View {
        // Integración del AnimatedSideBar
        AnimatedSideBar(
            rotatesWhenExpands: true,
            disablesInteraction: true,
            sideMenuWith: 200,
            cornerRadius: 25,
            showMenu: $showMenu
        ) { safeArea in
            GeometryReader { geometry in
                ZStack {
                    // Fondo de imagen
                    Image("bg2")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .ignoresSafeArea()
                        .opacity(0.5)

                    // Contenido principal
                    VStack(spacing: 20) {
                        // Título del Dashboard y Botón de Logout
                        HStack {
                            Button {
                                showMenu.toggle()
                            } label: {
                                Image(systemName: showMenu ? "xmark.circle.fill" : "line.horizontal.3")
                                    .font(.system(size: 30))
                                    .foregroundStyle(.white)
                                    .contentTransition(.symbolEffect)
                            }
                            .padding(.top, 2)

                            Text("¡Hola \(currentUser?.firstName ?? "Invitado")!")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            Image(systemName: "bell")
                                .foregroundColor(.white)

                            // Botón de Logout
                            Button(action: {
                                //loginModel.signOut()
                            }) {
                                Image(systemName: "person.circle")
                                    .foregroundColor(.white)
                                    .font(.title)
                            }
                            .padding()
                        }
                        .padding(.top, 40)
                        .padding(.horizontal)
                        //.background(Color.black.opacity(0.7))
                        
                        HStack {
                            Text("Esta es tu agenda de hoy")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .padding(.horizontal)
                            Spacer()
                        }
                        
                        
                        
                        // Resto del contenido del dashboard
                        ScrollView {
                            VStack(spacing: 10) {
                                
                                HStack {
                                    Button(action: {
                                        showingDatePicker.toggle()
                                    }) {
                                        HStack {
                                            Spacer()
                                            Text(formattedDate(selectedDate))
                                                .font(.headline)
                                                .foregroundColor(.black)
                                                
                                            
                                        }
                                    }
                                    .popover(isPresented: $showingDatePicker) {
                                        VStack {
                                            DatePicker(
                                                "Selecciona una fecha",
                                                selection: $selectedDate,
                                                displayedComponents: .date
                                            )
                                            .datePickerStyle(.graphical)
                                            .padding()
                                        }
                                    }
                                    
                                }
                                .padding(.bottom, 10)
                                
                                Divider()
                                    .padding(.bottom, 10)
                                // Aquí agregamos las citas
                                AppointmentView(name: "Mireia Carrera", service: "Semipermanente Manos Básica Refuerzo Gel en Uñas", time: "10:00 - 11:00", price: "22€", imageName: "person1")
                                AppointmentView(name: "Joan Parera", service: "Cutículas y vitaminas", time: "11:00 - 11:20", price: "10€", imageName: "person2")
                                AppointmentView(name: "Rosa Vila", service: "Nail Art", time: "11:20 - 13:20", price: "55€", imageName: "person3")
                            }
                            
                            
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
                .background(Color.black)
            }
        } menuView: { safeArea in
            SideBarMenuView(safeArea)
        } background: {
            Rectangle()
                .foregroundStyle(.gray)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "es_ES") // Establece el idioma español
            formatter.dateFormat = "EEEE, d 'de'  MMMM 'de' yyyy" // Formato personalizado
            return formatter.string(from: date)
        }

    @ViewBuilder
    func SideBarMenuView(_ safeArea: UIEdgeInsets) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Spacer(minLength: 0)
                Image("logo black")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 110)
                Spacer(minLength: 0)
            }
            Divider()
                .frame(height: 1)
                .background(.white)
                .padding(.vertical, 10)

            SideBarButton(.citas)
            SideBarButton(.estilistas)
            SideBarButton(.mensajes)
            SideBarButton(.reseñas)
            SideBarButton(.ajustes)
            

            Spacer(minLength: 0)

            SideBarButton(.logout) {
                loginModel.logout()
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
        .padding(.top, safeArea.top)
        .padding(.bottom, safeArea.bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    @ViewBuilder
    func SideBarButton(_ tab: StylistView.dash, onTap: @escaping () -> () = { }) -> some View {
        Button(action: {
            if tab == .ajustes {
                showMenu = false
            } else {
                onTap()
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: tab.rawValue)
                    .font(.title3)

                Text(tab.title)
                    .font(.callout)

                Spacer(minLength: 0)
            }
            .padding(.vertical, 10)
            .contentShape(.rect)
        }
        .foregroundStyle(.white)
    }
    
    enum dash: String, CaseIterable {
        
        case citas = "calendar"
        case estilistas = "person.crop.circle.fill"
        case mensajes = "mail.stack.fill"
        case reseñas = "star.leadinghalf.filled"
        case ajustes = "gear"
        case logout = "rectangle.portrait.and.arrow.right"
        
        var title: String {
            switch self {
            case .citas: return "Citas"
            case .estilistas: return "Mi Perfil"
            case .mensajes: return "Mensajes"
            case .reseñas: return "Reseñas"
            case .ajustes: return "Ajustes"
            case .logout: return "Cerrar sesión"
            }
        }
    }
}



#Preview {
    StylistView()
}
