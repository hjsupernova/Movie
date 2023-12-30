//
//  SignInEmailView.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import SwiftUI

import FirebaseAuth
import Firebase

struct SignInEmailView: View {
    @EnvironmentObject var favoriteMoviesManager: FavoriteMoviesManager
    @StateObject private var signInEmailViewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            emailTextField
            passwordSecureField
            VStack(spacing: 16) {
                signInButton
                signUpButton
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

    // MARK: - Computed properties

    private var emailTextField: some View {
        TextField("Email...", text: $signInEmailViewModel.email)
            .padding()
            .background(Color.gray.opacity(0.4))
            .cornerRadius(10)
            .keyboardType(.emailAddress)
    }
    
    private var passwordSecureField: some View {
        SecureField("Password...", text: $signInEmailViewModel.password)
            .padding()
            .background(Color.gray.opacity(0.4))
            .cornerRadius(10)
    }
    
    private var signInButton: some View {
        Button {
            Task {
                showSignInView = await !signInEmailViewModel.signIn(favoriteMoviesManager: favoriteMoviesManager)
            }
        } label: {
            Text("Sign In")
                .authenticationButton()
        }
    }

    private var signUpButton: some View {
        Button {
            Task {
                    showSignInView = await !signInEmailViewModel.signUp(favoriteMoviesManager: favoriteMoviesManager)
            }
        } label: {
            Text("Sign Up")
                .authenticationButton()
        }
    }
}

#Preview {
    SignInEmailView(showSignInView: .constant(false))
        .preferredColorScheme(.dark)
        .environmentObject(FavoriteMoviesManager())
}
