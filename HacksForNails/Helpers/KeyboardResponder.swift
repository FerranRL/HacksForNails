//
//  KeyboardResponder.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 4/7/24.
//
import SwiftUI
import Combine

class KeyboardResponder: ObservableObject {
    private var cancellable: AnyCancellable?
    
    @Published var currentHeight: CGFloat = 0

    init() {
        cancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .compactMap { notification in
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            }
            .map { rect in
                if rect.origin.y >= UIScreen.main.bounds.height {
                    return 0
                } else {
                    return rect.height
                }
            }
            .assign(to: \.currentHeight, on: self)
    }
}
