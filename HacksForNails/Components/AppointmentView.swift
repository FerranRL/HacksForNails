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

            var body: some View {
                HStack {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(name)
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text(service)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(time)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    Text(price)
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
            }
        }