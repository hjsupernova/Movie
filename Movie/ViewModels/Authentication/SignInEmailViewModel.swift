//
//  SignInEmailViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import Foundation

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = "hello@testing.com"
    @Published var password = "123456"
    @Published var showAlert = false
    @Published var alertMsg = ""
    @Published var alertTitle = ""
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("DEBUG: No email or password found.")
            return
        }
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        let user = DBUser(auth: authDataResult)
        try UserManager.shared.createNewUser(user: user)
        UserDefaults.standard.saveUser(user, forKey: .user)
    }
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("DEBUG: No email or password found.")
            return
        }
        let authDataResult = try await AuthenticationManager.shared.signInUser(email: email, password: password)
        let user = DBUser(auth: authDataResult)
        UserDefaults.standard.saveUser(user, forKey: .user)
    }
}
