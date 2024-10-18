//
//  Home.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 25/6/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct Home: View {
    @StateObject var serviceViewModel = ServiceViewModel()
    @State var segmentedTags: [String] = ["Ofertas", "Uñas", "Pestañas", "Facial", "Nutrición"]
    @State var selectedIndex: Int = 0
    @StateObject var loginModel: LoginViewModel = LoginViewModel.shared
    @State var showMenu: Bool = false
    @State var profileImage: UIImage? = nil
    @State var currentUser = LoginViewModel.shared.currentUser
    @State private var navigationPath: [NavigationDestination] = []
    
    var user: User
    
    // Datos de ejemplo para los servicios
//    let servicesByCategory: [String: [ServiceData]] = [
//        "Ofertas": [
//            ServiceData(imageName: "nail_art", title: "Semipermanente Manos Básica + Refuerzo Gel en Uñas", price: "22€"),
//            ServiceData(imageName: "pedicura", title: "Pedicura Express - Retirada de Durezas + Exfoliación + Masaje Hidratante + Esmaltado (Pedicura)", price: "36€"),
//            ServiceData(imageName: "cejas", title: "Diseño de Cejas - Tinte de Cejas", price: "20€"),
//            ServiceData(imageName: "cejas2", title: "Laminado de Cejas - Tinte de Cejas", price: "40€")
//        ],
//        "Uñas": [
//            ServiceData(imageName: "placeholder", title: "Manicura Semipermanente", price: "25€"),
//            ServiceData(imageName: "placeholder", title: "Uñas de Gel", price: "40€"),
//            ServiceData(imageName: "placeholder", title: "Nail Art Personalizado", price: "15€")
//        ],
//        "Pestañas": [
//            ServiceData(imageName: "placeholder", title: "Servicio 1", price: "25€"),
//            ServiceData(imageName: "placeholder", title: "Servicio 2", price: "40€"),
//            ServiceData(imageName: "placeholder", title: "Nail Art Personalizado", price: "15€")
//        ],
//        "Facial": [
//            ServiceData(imageName: "placeholder", title: "Limpieza Facial Profunda", price: "45€"),
//            ServiceData(imageName: "placeholder", title: "Mascarilla Hidratante", price: "30€"),
//            ServiceData(imageName: "placeholder", title: "Peeling Facial", price: "50€")
//        ],
//        "Nutrición": [
//            ServiceData(imageName: "placeholder", title: "Consulta Nutricional", price: "60€"),
//            ServiceData(imageName: "placeholder", title: "Plan de Alimentación Personalizado", price: "80€"),
//            ServiceData(imageName: "placeholder", title: "Seguimiento Nutricional Mensual", price: "40€")
//        ]
//    ]
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            AnimatedSideBar(
                rotatesWhenExpands: true,
                disablesInteraction: true,
                sideMenuWith: 200,
                cornerRadius: 25,
                showMenu: $showMenu
            ) { safeArea in
                GeometryReader { geometry in
                    ZStack {
                        Image("bg2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                // Saludo y foto de perfil
                                HStack(alignment: .center, spacing: 20) {
                                    Button {
                                        showMenu.toggle()
                                    } label: {
                                        Image(systemName: showMenu ? "xmark.circle.fill" : "line.horizontal.3")
                                            .font(.system(size: 30))
                                            .fontWeight(.light)
                                            .foregroundStyle(.white)
                                            .contentTransition(.symbolEffect)
                                    }
                                    .padding(.top, 2)
                                    
                                    Text("¡Hola \(currentUser?.firstName ?? "")!")
                                        .font(.title)
                                        .foregroundStyle(.white)
                                    Spacer()
                                    Button {
                                        navigationPath.append(.profile)
                                    } label: {
                                        if let pImage = loginModel.profileImage {
                                            Image(uiImage: pImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                                .shadow(radius: 10)
                                        } else {
                                            Image("bg2")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                                .shadow(radius: 10)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .frame(height: 55)
                                
                                Text("¿Qué servicio podemos ofrecerte?")
                                    .font(.title)
                                    .padding()
                                    .foregroundStyle(.white)
                                
                                SegmentedControl(selectedIndex: $selectedIndex, options: $segmentedTags)
                                    .padding(.horizontal)
                                
                                // Carrusel de ServiceCard
                                serviceCarousel()
                            }
                        }
                        .padding(.top, 80)
                    }
                }
                .navigationBarBackButtonHidden(true)
                .edgesIgnoringSafeArea(.all)
                .background(Color.black)
                .onAppear {
                    loginModel.loadUserData()
                }
            } menuView: { safeArea in
                SideBarMenuView(safeArea)
            } background: {
                Rectangle()
                    .foregroundStyle(.gray)
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .profile:
                    ProfileView()
                }
            }
        }
    }
    
    // Función que genera el carrusel de servicios
    @ViewBuilder
    func serviceCarousel() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                // Extraer los servicios de la categoría seleccionada
                if let services = serviceViewModel.servicesByCategory[segmentedTags[selectedIndex]] {
                    ForEach(services, id: \.id) { service in
                        ServiceCard(
                            imageName: service.imageURL ?? "placeholder",
                            title: service.title,
                            price: "\(service.price)"
                        )
                        .frame(width: 300)
                    }
                } else {
                    Text("No hay servicios disponibles")
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
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
            
            SideBarButton(.inicio)
            SideBarButton(.calendar)
            SideBarButton(.ajustes)
            SideBarButton(.perfil)
            
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
    func SideBarButton(_ tab: Tab, onTap: @escaping () -> () = { }) -> some View {
        Button(action: {
            if tab == .perfil {
                showMenu = false
                navigationPath.append(.profile)
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
    
    enum Tab: String, CaseIterable {
        case inicio = "house.fill"
        case calendar = "calendar"
        case ajustes = "gear"
        case perfil = "person.crop.circle.fill"
        case logout = "rectangle.portrait.and.arrow.right"
        
        var title: String {
            switch self {
            case .inicio: return "Inicio"
            case .calendar: return "Mis reservas"
            case .ajustes: return "Ajustes"
            case .perfil: return "Mi Perfil"
            case .logout: return "Cerrar sesión"
            }
        }
    }
    
    enum NavigationDestination: Hashable {
        case profile
    }
}

// Estructura para los datos del servicio
struct ServiceData: Identifiable {
    let id: String
    var imageURL: String?
    var title: String
    var price: Double
    var duracion: Int
    var descripcion: String
    var categorias: [String]  // Las categorías serán un array de strings
}

