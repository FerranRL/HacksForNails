//
//  AppointmentView.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 10/9/24.
//


import SwiftUI

struct AppointmentView: View {
    var name: String
    var service: String
    var time: String
    var price: String
    var imageName: String
    var showMore: Bool? = true
    
    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 79, height: 79)
                .background(Color.black.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            
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
