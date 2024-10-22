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

    let dates = ["Oct 20", "Oct 21", "Oct 22", "Oct 23", "Oct 24", "Oct 25"]
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
}

struct HorizontalPicker: View {
    let items: [String]
    @Binding var selectedIndex: Int

    @State private var dragOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            let itemWidth = geometry.size.width / 3 // 3 items visible at a time
            let centerX = geometry.size.width / 2

            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { scrollView in
                    HStack(spacing: 10) {
                        ForEach(0..<items.count, id: \.self) { index in
                            Text(items[index])
                                .font(.system(size: 20, weight: index == selectedIndex ? .bold : .regular))
                                .foregroundColor(index == selectedIndex ? .black : .gray) // White for selected, gray for others
                                .frame(width: itemWidth, height: 80)
                                .background {
                                    if index == selectedIndex {
                                        Color.white
                                    } else {
                                        LinearGradient(gradient: Gradient(colors: [.gray.opacity(0.6), .gray.opacity(0.3)]), startPoint: .leading, endPoint: .trailing)
                                    }
                                }
                                .cornerRadius(10)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        selectedIndex = index
                                        scrollView.scrollTo(index, anchor: .center)
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, (geometry.size.width - itemWidth) / 2) // Center first and last elements
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation.width
                            }
                            .onEnded { value in
                                let dragThreshold: CGFloat = 50 // Adjust to your needs
                                if dragOffset > dragThreshold && selectedIndex > 0 {
                                    selectedIndex -= 1
                                } else if dragOffset < -dragThreshold && selectedIndex < items.count - 1 {
                                    selectedIndex += 1
                                }
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
