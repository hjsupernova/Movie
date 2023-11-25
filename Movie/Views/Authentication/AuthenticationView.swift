//
//  AuthenticationView.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct AuthenticationView: View {
    @EnvironmentObject var libraryVM: LibraryViewModel
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        VStack {
            VStack {
                Text("🍿")
                Text("Login to a reel world of movie memories")
            }
            .multilineTextAlignment(.center)
            .font(.largeTitle.bold())
            
            VStack {
                NavigationLink {
                    SignInEmailView(showSignInView: $showSignInView)
                } label: {
                    Text("Sign Up With Email")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .cornerRadius(10)
                }
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .standard, state: .normal)) {
                    Task {
                        do {
                            try await viewModel.signInGoogle()
                            guard let user = UserDefaults.standard.loadUser(DBUser.self, forKey: .user) else { return }
                            libraryVM.userId = user.userId
                            libraryVM.getLocalFavMovies(userId: user.userId)
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
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
