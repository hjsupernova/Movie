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
    @EnvironmentObject var libraryVM: LibraryViewModel
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        VStack {
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
                .keyboardType(.emailAddress)
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            VStack(spacing: 16) {
                // SignIn
                Button {
                    Task {
                        do {
                            try await viewModel.signIn()
                            guard let user = UserDefaults.standard.loadUser(DBUser.self, forKey: .user) else {
                                Logger.auth.error("DEBUG: Failed to signUp with Email")
                                return
                            }
                            libraryVM.userId = user.userId
                            libraryVM.loadLocalFavoriteMovies(userId: user.userId)
                            showSignInView = false
                            return
                        } catch {
                            viewModel.alertTitle = "SignIn Error"
                            viewModel.alertMsg = error.localizedDescription
                            viewModel.showAlert = true
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
                            try await viewModel.signUp()
                            guard let user = UserDefaults.standard.loadUser(DBUser.self, forKey: .user) else {
                                Logger.auth.error("DEBUG: Failed to signUp with Email")
                                return
                            }
                            libraryVM.userId = user.userId
                            libraryVM.loadLocalFavoriteMovies(userId: user.userId)
                            showSignInView = false
                            return
                        } catch let error as NSError {
                            viewModel.alertTitle = "SignUp Error"
                            viewModel.alertMsg = error.localizedDescription
                            viewModel.showAlert = true
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
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("Cancle") { }
        } message: {
            Text(viewModel.alertMsg)
        }
        .padding()
        .navigationTitle("Sign In with Email")
    }
}

#Preview {
    SignInEmailView(showSignInView: .constant(false))
        .preferredColorScheme(.dark)
        .environmentObject(LibraryViewModel())
}
