//
//  AuthenticationViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(credentials: tokens)
        let user = DBUser(auth: authDataResult)
        try UserManager.shared.createNewUser(user: user)
        UserDefaults.standard.saveUser(user, forKey: .user)
    }
}
