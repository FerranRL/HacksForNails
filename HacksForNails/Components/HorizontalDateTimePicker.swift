//
//  HorizontalDateTimePicker.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 22/10/24.
//
import SwiftUI

struct HorizontalDateTimePicker: View {
    @State private var selectedDateIndex = 2
    @State private var selectedTimeIndex = 2

    let dates = generateDates()
    let times = ["10:00", "11:00", "12:00", "13:00", "14:00", "15:00"]

    var body: some View {
        VStack(spacing: 5) {
            // Date Picker
            HorizontalPicker(items: dates, selectedIndex: $selectedDateIndex)
                .frame(height: 100)
                .padding(.top, 20)

            // Time Picker
            HorizontalPicker(items: times, selectedIndex: $selectedTimeIndex)
                .frame(height: 100)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Fondo negro
    }

    static func generateDates() -> [String] {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateFormat = "dd MMM"

        var dates = [String]()
        // 1 day before today
        if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) {
            dates.append(dateFormatter.string(from: yesterday))
        }
        // From today to 6 months + 1 day
        for i in 0...181 {
            if let futureDate = Calendar.current.date(byAdding: .day, value: i, to: today) {
                dates.append(dateFormatter.string(from: futureDate))
            }
        }
        return dates
    }
}

struct HorizontalPicker: View {
    let items: [String]
    @Binding var selectedIndex: Int

    @State private var dragOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            let itemWidth = geometry.size.width / 3 // 3 items visible at a time
            //let centerX = geometry.size.width / 2
            let todayIndex = 1 // Hoy será el índice 1 (porque el índice 0 es ayer)

            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { scrollView in
                    HStack(spacing: 10) {
                        ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                            let isSelected = index == selectedIndex

                            let textColor: LinearGradient = isSelected ?
                            LinearGradient(gradient: Gradient(colors: [Color.black]), startPoint: .leading, endPoint: .trailing) :
                            (index < selectedIndex ?
                                LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5), .gray]), startPoint: .leading, endPoint: .trailing) :
                                LinearGradient(gradient: Gradient(colors: [.gray, .black.opacity(0.5)]), startPoint: .leading, endPoint: .trailing))

                            let backgroundGradient = isSelected ?
                                LinearGradient(gradient: Gradient(colors: [Color.white]), startPoint: .leading, endPoint: .trailing) :
                                (index < selectedIndex ?
                                    LinearGradient(gradient: Gradient(colors: [.black, .gray.opacity(0.8)]), startPoint: .leading, endPoint: .trailing) :
                                    LinearGradient(gradient: Gradient(colors: [.gray.opacity(0.8), .black]), startPoint: .leading, endPoint: .trailing))

                            Text(item)
                                .font(.system(size: 20, weight: isSelected ? .bold : .regular))
                                .foregroundStyle(textColor) // Aplicamos el color de texto como LinearGradient
                                .frame(width: itemWidth, height: 80)
                                .background(backgroundGradient) // Fondo con gradiente
                                .cornerRadius(10)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if index >= todayIndex { // Solo permitir seleccionar desde hoy en adelante
                                        withAnimation {
                                            selectedIndex = index
                                            scrollView.scrollTo(index, anchor: .center)
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, (geometry.size.width - itemWidth) / 2) // Centrar primer y último elementos
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation.width
                            }
                            .onEnded { value in
                                //let dragThreshold: CGFloat = 50
                                let newOffset = dragOffset + value.predictedEndTranslation.width
                                let estimatedIndex = selectedIndex - Int(newOffset / itemWidth)

                                // Solo permitir seleccionar fechas a partir de hoy
                                selectedIndex = max(todayIndex, min(estimatedIndex, items.count - 1))
                                
                                withAnimation {
                                    scrollView.scrollTo(selectedIndex, anchor: .center)
                                }
                                dragOffset = 0 // Reset the drag offset
                            }
                    )
                    .onAppear {
                        scrollView.scrollTo(selectedIndex, anchor: .center) // Scroll to initially selected element
                    }
                }
            }
        }
    }
}

#Preview {
    HorizontalDateTimePicker()
}
