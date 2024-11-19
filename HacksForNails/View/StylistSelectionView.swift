import SwiftUI

struct StylistSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedStylist: Stylist?
    @Binding var selectedSalon: Salon?
    
    let stylists = [
        Stylist(name: "Irina", imageName: "profile_photo"),
        Stylist(name: "Laia", imageName: "person1"),
        Stylist(name: "Primer@ Disponible", imageName: "placeholder")
    ]
    
    let salons: [Salon] = [
        Salon(name: "Parets", imageName: "salon1"),
        Salon(name: "Granollers", imageName: "salon2")
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                salonSelectionSection()
                stylistSelectionSection()
            }
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            if selectedSalon == nil {
                selectedSalon = salons.first
            }
        }
    }
    
    @ViewBuilder
    private func salonSelectionSection() -> some View {
        
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
        }
        .padding(.leading, 10)
        .ignoresSafeArea(edges: .top)
        
        VStack {
            Text("Selecciona Salón")
                .font(.title)
                .foregroundColor(.white)
                .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(salons, id: \.name) { salon in
                        SalonCard(salon: salon, isSelected: selectedSalon == salon) {
                            selectedSalon = salon
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private func stylistSelectionSection() -> some View {
        VStack {
            Text("Selecciona tu estilista")
                .font(.title)
                .foregroundColor(.white)
                .padding()
            
            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 20) {
                ForEach(stylists, id: \.name) { stylist in
                    StylistCard(stylist: stylist, selectedStylist: $selectedStylist) {
                        selectedStylist = stylist
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .padding()
        }
    }
}

// Modelos y vistas auxiliares
struct Salon: Equatable {
    let name: String
    let imageName: String
}

struct SalonCard: View {
    let salon: Salon
    var isSelected: Bool
    var onSelect: () -> Void
    
    var body: some View {
        VStack {
            Image(salon.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Text(salon.name)
                .foregroundColor(isSelected ? .black : .white)
                .font(.headline)
        }
        .frame(width: 130, height: 160)
        .background(isSelected ? Color.white : Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .onTapGesture {
            onSelect()
        }
    }
}

struct Stylist {
    let name: String
    let imageName: String
}

struct StylistCard: View {
    let stylist: Stylist
    @Binding var selectedStylist: Stylist?
    var onSelect: () -> Void
    
    var body: some View {
        VStack {
            Image(stylist.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Text(stylist.name)
                .foregroundColor(.white)
                .font(.headline)
            
            StylistCardButtons(stylist: stylist, selectedStylist: $selectedStylist, onSelect: onSelect)
        }
        .frame(width: 150, height: 220)
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct StylistCardButtons: View {
    let stylist: Stylist
    @Binding var selectedStylist: Stylist?
    var onSelect: () -> Void
    
    var body: some View {
        HStack {
            if stylist.name == "Primer@ Disponible" {
                Button(action: {
                    onSelect()
                }) {
                    Text("+")
                        .font(.caption)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                }
            } else {
                NavigationLink(destination: StylistDataView(
                    stylistName: stylist.name,
                    stylistImage: stylist.imageName,
                    stylistWorks: ["work1", "work2", "work3"],
                    onSelect: {
                        selectedStylist = stylist // Acción para seleccionar estilista
                        }
                )) {
                    Text("Ver ficha")
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                }
                
                Spacer()
                
                Button(action: {
                    onSelect()
                }) {
                    Text("+")
                        .font(.caption)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                }
            }
        }
        .padding(.horizontal, 15)
    }
}
