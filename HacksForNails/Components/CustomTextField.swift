//
//  CustomTextField.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 20/6/24.
//

import SwiftUI

enum FocusedField: Hashable {
    case field1
    case field2
    case field3
}

struct CustomTextField: View {
    var hint: String
    var hintColor: Color = .gray
    @Binding var text: String
    var contentType: UITextContentType = .telephoneNumber
    var focusedField: FocusState<FocusedField?>.Binding
    var currentField: FocusedField
    

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(hint)
                        .foregroundColor(hintColor)
                        .padding(.leading, 4)
                }
                TextField(hint, text: $text)
                    .keyboardType(.alphabet)
                    .autocorrectionDisabled(true)
                    .foregroundColor(.white)
                    .textContentType(contentType)
                    .focused(focusedField, equals: currentField)
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            if focusedField.wrappedValue == currentField {
                                HStack {
                                    Spacer()
                                    Button("Aceptar") {
                                        focusedField.wrappedValue = nil
                                    }
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(.gray)
                                        
                                    }
                                }
                                
                                
                            }
                        }
                    }
                
                
            }
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.white.opacity(0.5))
                Rectangle()
                    .fill(.white)
                    .frame(width: focusedField.wrappedValue == currentField ? nil : 0, alignment: .leading)
                    .animation(.easeInOut(duration: 0.3), value: focusedField.wrappedValue == currentField)
            }
            .frame(height: 2)
        }
        .padding(.horizontal)
        
    }
}

#Preview {
    ContentView()
}
