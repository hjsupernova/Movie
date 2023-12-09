//
//  AuthenticationManager.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import Foundation

import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoURL: String?
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
    }
}

enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
}

enum FIRAuthError: Error {
    case noAuthenticatedUser
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() {}
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw FIRAuthError.noAuthenticatedUser
        }
        return AuthDataResultModel(user: user)
    }
    func signOut() throws {
        try Auth.auth().signOut()
    }
    func delete() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        try await user.delete()
    }
}

// MARK: - SIGN IN EMAIL

extension AuthenticationManager {
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
}

// MARK: - SIGN IN SSO

extension AuthenticationManager {
    @discardableResult
    func signInWithGoogle(credentials: GoogleSignInResult) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: credentials.idToken,
                                                       accessToken: credentials.accessToken)
        return try await signIn(credentials: credential)
    }
    func signIn(credentials: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credentials)
        return AuthDataResultModel(user: authDataResult.user)
    }
}
