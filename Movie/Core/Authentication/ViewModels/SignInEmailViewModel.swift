//
//  SignInEmailViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import Foundation
import OSLog

import FirebaseAuth

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
            handleSignUpError(error)
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
            handleSignInError(error)
            return false
        }
    }

    private func handleSignUpError(_ error: Error) {
        if let error = error as NSError? {
            if let authError = AuthErrorCode.Code(rawValue: error.code) {
                switch authError {
                case .networkError:
                    alertMsg = "Network error occurred. Please check your internet connection and try again."
                case .invalidEmail:
                    alertMsg = "Invalid email address. Please enter a valid email."
                case .emailAlreadyInUse:
                    alertMsg = "The email is already in use with another account."
                case .weakPassword:
                    alertMsg = "Your password is too weak. The password must be 6 characters long or more."
                default:
                    alertMsg = "An unknown authentication error occurred."
                }
            }
        }
        alertTitle = "SignUp Error"
        showAlert = true

        Logger.auth.error("\(error)")
    }

    private func handleSignInError(_ error: Error) {
        if let error = error as NSError? {
            if let authError = AuthErrorCode.Code(rawValue: error.code) {
                switch authError {
                case .networkError:
                    alertMsg = "Network error occurred. Please try again."
                case .invalidEmail:
                    alertMsg = "Invalid email address. Please enter a valid email."
                case .userDisabled:
                    alertMsg = "Your account has been disabled. Please contact support."
                case .wrongPassword:
                    alertMsg = "Incorrect password. Please try again or use 'Forgot password' to reset your password."
                default:
                    alertMsg = "An unknown authentication error occurred."
                }
            }
        }
        alertTitle = "SignIn Error"
        showAlert = true

        Logger.auth.error("\(error)")
    }

}
