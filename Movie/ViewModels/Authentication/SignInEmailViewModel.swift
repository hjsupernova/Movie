//
//  SignInEmailViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import Foundation

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("DEBUG: No email or password found.")
            return
        }
        try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("DEBUG: No email or password found.")
            return
        }
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}
