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
    @EnvironmentObject var libraryVM: LibraryViewModel
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            VStack(spacing: 12) {
                Text("🍿")
                Text("Login to a reel world of movie memories.")
            }
            .multilineTextAlignment(.center)
            .font(.largeTitle.bold())
            VStack(spacing: 16) {
                NavigationLink {
                    SignInEmailView(showSignInView: $showSignInView)
                } label: {
                    Label("Sign In with Email", systemImage: "envelope")
                        .authenticationButton()
                }
                Button {
                    Task {
                        do {
                            try await viewModel.signInGoogle()
                            guard let user = UserDefaults.standard.loadUser(DBUser.self, forKey: .user) else { return }
                            libraryVM.userId = user.userId
                            libraryVM.loadLocalFavoriteMovies(userId: user.userId)
                            showSignInView = false
                        } catch {
                            Logger.auth.error("\(error.localizedDescription)")
                        }
                    }
                } label: {
                    Label("Sign in with Google", image: "Google")
                        .authenticationButton()
                }
            }
            .padding(.vertical)
        }
        .padding()
    }
}

#Preview {
    AuthenticationView(showSignInView: .constant(false))
        .preferredColorScheme(.dark)
}
