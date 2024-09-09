//
//  DashboardView.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 6/9/24.
//

import SwiftUI

struct DashboardView: View {
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

                            Text("Dashboard")
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
                            VStack(spacing: 20) {
                                HStack(spacing: 6) {
                                    Spacer()
                                    SummaryCardView(title: "Clientes", count: "1000")
                                    SummaryCardView(title: "Servicios", count: "56")
                                    SummaryCardView(title: "Citas", count: "900")
                                    Spacer()
                                }
                                .padding(.horizontal)

                                // Gráficas y Vistas adicionales
                                ChartCardView(title: "Género", chartType: .pie)
                                    .frame(width: geometry.size.width - 40)
                                ChartCardView(title: "Citas por horas", chartType: .bar)
                                    .frame(width: geometry.size.width - 40)
                                UpcomingAppointmentsView()
                                    .frame(width: geometry.size.width - 40)
                                FinancialTargetView()
                                    .frame(width: geometry.size.width - 40)

                                Spacer(minLength: 20)
                            }
                            .padding(.horizontal)
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

// Componentes Personalizados
struct SummaryCardView: View {
    var title: String
    var count: String

    var body: some View {
        VStack {
            Text(count)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(title)
                .foregroundColor(.white)
                .font(.subheadline)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
}

struct ChartCardView: View {
    enum ChartType {
        case pie, bar
    }

    var title: String
    var chartType: ChartType

    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.bottom, 5)

            if chartType == .pie {
                PieChartView()
                    .frame(height: 200)
            } else {
                BarChartView()
                    .frame(height: 200)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct UpcomingAppointmentsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Próximas Citas")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)

            ForEach(0..<5) { _ in
                AppointmentRowView()
            }
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct AppointmentRowView: View {
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
            VStack(alignment: .leading) {
                Text("Nombre del Cliente")
                    .foregroundColor(.white)
                Text("Detalles de la cita")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            Spacer()
            Text("22€")
                .foregroundColor(.white)
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
    }
}

struct FinancialTargetView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Objetivo financiero")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal)
            
            LineChartView()
                .frame(height: 200)
                .padding(.horizontal)
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

// Dummy chart views
struct PieChartView: View {
    var body: some View {
        Circle()
            .fill(Color.red)
    }
}

struct BarChartView: View {
    var body: some View {
        Rectangle()
            .fill(Color.blue)
    }
}

struct LineChartView: View {
    var body: some View {
        Rectangle()
            .fill(Color.purple)
    }
}

#Preview {
    DashboardView()
}
