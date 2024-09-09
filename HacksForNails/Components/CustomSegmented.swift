//
//  CustomSegmented.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 26/6/24.
//

import SwiftUI

struct SegmentedControl: View {
    @Binding var selectedIndex: Int
    @Binding var options: [String]

    var body: some View {
        HStack {
            ForEach(0..<options.count, id: \.self) { index in
                Button(action: {
                    selectedIndex = index
                }) {
                    Text(options[index])
                        .padding(.trailing, 8)
                        .background(Color.clear)
                        .foregroundColor(selectedIndex == index ? Color.white : Color.white.opacity(0.5))
                        .cornerRadius(5)
                }
            }
        }
    }
}

