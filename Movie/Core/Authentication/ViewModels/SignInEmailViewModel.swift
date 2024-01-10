//
//  SignInEmailViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import Foundation
import OSLog

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = "hello@testing.com"
    @Published var password = "123456"
    @Published var showAlert = false
    @Published var alertMsg = ""
    @Published var alertTitle = ""

    func signUp(favoriteMoviesManager: FavoriteMoviesManager) async -> Bool {
        do {
            guard !email.isEmpty, !password.isEmpty else {
                Logger.auth.error("DEBUG: No email or password found.")
                return false
            }

            let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
            let user = DBUser(auth: authDataResult)

            try UserManager.shared.createNewUser(user: user)

            UserDefaults.standard.saveUser(user, forKey: .user)
            
            favoriteMoviesManager.userId = user.userId
            favoriteMoviesManager.loadLocalFavoriteMovies(userId: user.userId)

            return true
        } catch {
            alertTitle = "SignUp Error"
            alertMsg = error.localizedDescription
            showAlert = true

            return false
        }
    }
    
    func signIn(favoriteMoviesManager: FavoriteMoviesManager) async -> Bool {
        do {
            guard !email.isEmpty, !password.isEmpty else {
                Logger.auth.error("DEBUG: No email or password found.")
                return false
            }
            let authDataResult = try await AuthenticationManager.shared.signInUser(email: email, password: password)
            let user = DBUser(auth: authDataResult)
            UserDefaults.standard.saveUser(user, forKey: .user)

            favoriteMoviesManager.userId = user.userId
            favoriteMoviesManager.loadLocalFavoriteMovies(userId: user.userId)
            return true
        } catch {
            alertTitle = "SignIn Error"
            alertMsg = error.localizedDescription
            showAlert = true

            return false
        }
    }

}
