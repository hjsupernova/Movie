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
        // Email외 구글로그인 시 날짜 값 때문에 Firestore에 유저 Document가 덮어쓰기 된다.
        // 유저가 값이 있는 경우 새로운 저장하지 않도록 getUser 함수 먼저 실행.
        do {
            try await UserManager.shared.getUser(userId: user.userId)
        } catch {
            try UserManager.shared.createNewUser(user: user)
        }
        UserDefaults.standard.saveUser(user, forKey: .user)
    }
}
