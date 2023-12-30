//
//  SignInEmailView.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import OSLog
import SwiftUI

import FirebaseAuth
import Firebase

struct SignInEmailView: View {
    @EnvironmentObject var favoriteMoviesManager: FavoriteMoviesManager
    @StateObject private var signInEmailViewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            TextField("Email...", text: $signInEmailViewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
                .keyboardType(.emailAddress)
            SecureField("Password...", text: $signInEmailViewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            VStack(spacing: 16) {
                // SignIn
                Button {
                    Task {
                        do {
                            try await signInEmailViewModel.signIn()
                            guard let user = UserDefaults.standard.loadUser(DBUser.self, forKey: .user) else {
                                Logger.auth.error("DEBUG: Failed to signUp with Email")
                                return
                            }
                            favoriteMoviesManager.userId = user.userId
                            favoriteMoviesManager.loadLocalFavoriteMovies(userId: user.userId)
                            showSignInView = false
                            return
                        } catch {
                            signInEmailViewModel.alertTitle = "SignIn Error"
                            signInEmailViewModel.alertMsg = error.localizedDescription
                            signInEmailViewModel.showAlert = true
                        }
                    }
                } label: {
                    Text("Sign In")
                        .authenticationButton()
                }
                // SignUp
                Button {
                    Task {
                        do {
                            try await signInEmailViewModel.signUp()
                            guard let user = UserDefaults.standard.loadUser(DBUser.self, forKey: .user) else {
                                Logger.auth.error("DEBUG: Failed to signUp with Email")
                                return
                            }
                            favoriteMoviesManager.userId = user.userId
                            favoriteMoviesManager.loadLocalFavoriteMovies(userId: user.userId)
                            showSignInView = false
                            return
                        } catch let error as NSError {
                            signInEmailViewModel.alertTitle = "SignUp Error"
                            signInEmailViewModel.alertMsg = error.localizedDescription
                            signInEmailViewModel.showAlert = true
                        }
                    }
                } label: {
                    Text("Sign Up")
                        .authenticationButton()
                }
            }
            .padding(.vertical)
            Spacer()
        }
        .alert(signInEmailViewModel.alertTitle, isPresented: $signInEmailViewModel.showAlert) {
            Button("Cancle") { }
        } message: {
            Text(signInEmailViewModel.alertMsg)
        }
        .padding()
        .navigationTitle("Sign In with Email")
    }
}

#Preview {
    SignInEmailView(showSignInView: .constant(false))
        .preferredColorScheme(.dark)
        .environmentObject(FavoriteMoviesManager())
}
