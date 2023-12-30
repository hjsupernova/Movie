//
//  AuthenticationView.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import OSLog
import SwiftUI

import GoogleSignIn
import GoogleSignInSwift

struct AuthenticationView: View {
    @EnvironmentObject var favoriteMoviesManager: FavoriteMoviesManager
    @StateObject private var authenticationViewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            headerSection
            buttonSection
        }
        .padding()
    }

    // MARK: - Computed Views
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("🍿")
            Text("Login to a reel world of movie memories.")
        }
        .multilineTextAlignment(.center)
        .font(.largeTitle.bold())
    }

    private var buttonSection: some View {
        VStack(spacing: 16) {
            emailSignInButton
            googleSignInButton
        }
        .padding(.vertical)

    }

    private var emailSignInButton: some View {
        NavigationLink {
            SignInEmailView(showSignInView: $showSignInView)
        } label: {
            Label("Sign In with Email", systemImage: "envelope")
                .authenticationButton()
        }
    }

    private var googleSignInButton: some View {
        Button {
            Task {
                showSignInView =  await !authenticationViewModel.signInGoogle(favoriteMoviesManager: favoriteMoviesManager)
            }
        } label: {
            Label("Sign in with Google", image: "Google")
                .authenticationButton()
        }
    }
}

#Preview {
    AuthenticationView(showSignInView: .constant(false))
        .preferredColorScheme(.dark)
}
