//
//  AppointmentView.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 10/9/24.
//


import SwiftUI
import SDWebImageSwiftUI

struct AppointmentView: View {
    var name: String
    var service: String
    var time: String
    var price: String
    var imageName: String?
    var showMore: Bool? = true
    
    var body: some View {
        HStack {
            if let imageName = imageName, let url = URL(string: imageName) {
                            WebImage(url: url)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 79, height: 79)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .background(Color.black.opacity(0.1))
                        } else {
                            Image("person1") // Usa una imagen predeterminada si no hay URL
                                .resizable()
                                .scaledToFill()
                                .frame(width: 79, height: 79)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .background(Color.black.opacity(0.1))
                        }
            
            
            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(service)
                    .font(.caption)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(time)
                    .font(.callout)
                    .foregroundColor(.black)
            }
            Spacer()
            
            VStack {
                if showMore == true {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.gray)
                        .padding(.top, 8)
                }

                Spacer()
                
                Text(price)
                    .font(.headline)
                    .foregroundColor(.black)
            }
            
        }
        .frame(height: 79)
        .background(Color.white)
        .padding(.bottom, 10)
    }
}

#Preview {
    StylistView()
}
