//
//  LoadingView.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 24/9/24.
//


import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    let logoImageName: String = "logo" // Cambia "logo" por el nombre de tu imagen de logo
    
    var body: some View {
        ZStack {
            // Fondo con imagen
            GeometryReader { geometry in
                Color(.black)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
                
                Image("bg2") // Cambia "bg2" por el nombre de tu imagen de fondo
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.5)
            }
            
            VStack {
                // Logo giratorio
                Image(logoImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .rotation3DEffect(
                        Angle(degrees: isAnimating ? 360 : 0),
                        axis: (x: 0, y: 1, z: 0) // Girando alrededor del eje Y para simular rotación en Z
                    )
                    .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: isAnimating)
                    .onAppear {
                        isAnimating = true
                    }
                    .padding(.bottom, 30)
                
                // Texto animado "Cargando datos..."
                Text("Cargando datos...")
                    .font(.title2)
                    .foregroundColor(.white)
                    .opacity(isAnimating ? 0 : 1) // Animación de parpadeo
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
