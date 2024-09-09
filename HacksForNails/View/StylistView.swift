//
//  StylistView.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 9/9/24.
//

import SwiftUI

struct StylistView: View {
    @EnvironmentObject var loginModel: LoginViewModel
    @State private var showMenu: Bool = false

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

                            Text("Stylist View")
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
                        .background(Color.black.opacity(0.7))

                        // Resto del contenido del dashboard
                        ScrollView {
                            UpcomingAppointmentsView()
                        }
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

            SideBarButton(.vista)
            SideBarButton(.citas)
            SideBarButton(.clientes)
            SideBarButton(.estilistas)
            SideBarButton(.mensajes)
            SideBarButton(.reseñas)
            SideBarButton(.contabilidad)
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
    func SideBarButton(_ tab: DashboardView.dash, onTap: @escaping () -> () = { }) -> some View {
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
        case vista = "house.fill"
        case citas = "calendar"
        case clientes = "person.fill"
        case estilistas = "person.crop.circle.fill"
        case mensajes = "mail.stack.fill"
        case reseñas = "star.leadinghalf.filled"
        case contabilidad = "creditcard.fill"
        case ajustes = "gear"
        case logout = "rectangle.portrait.and.arrow.right"
        
        var title: String {
            switch self {
            case .vista: return "Vista general"
            case .citas: return "Citas"
            case .clientes: return "Clientes"
            case .estilistas: return "Estilistas"
            case .mensajes: return "Mensajes"
            case .reseñas: return "Reseñas"
            case .contabilidad: return "Contabilidad"
            case .ajustes: return "Ajustes"
            case .logout: return "Cerrar sesión"
            }
        }
    }
}



#Preview {
    StylistView()
}
