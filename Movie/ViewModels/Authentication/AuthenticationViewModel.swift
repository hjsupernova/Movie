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
        
        // 구글로그인 시 날짜 값 때문에 Firestore에 유저 Document가 덮어쓰기 된다. ( Email 로그인은 덮어쓰기 x )
        // 유저가 값이 있는 경우 덮어쓰지 않도록 서버DB의 유저 정보 확인 
        do {
            try await UserManager.shared.getUser(userId: user.userId)
        } catch {
            try UserManager.shared.createNewUser(user: user)
        }
        UserDefaults.standard.saveUser(user, forKey: .user)
    }
}
