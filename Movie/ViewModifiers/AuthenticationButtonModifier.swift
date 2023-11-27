//
//  AuthenticationButtonModifier.swift
//  Movie
//
//  Created by KHJ on 2023/11/27.
//

import Foundation
import SwiftUI

struct AuthenticationButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content                        .font(.headline)
            .foregroundStyle(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(.blue)
            .cornerRadius(10)
    }
}

extension View {
    func authenticationButton() -> some View {
        modifier(AuthenticationButtonModifier())
    }
}
