//
//  AuthenticationViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import Foundation
import OSLog


@MainActor
final class AuthenticationViewModel: ObservableObject {
    var user: DBUser? {
        UserDefaults.standard.loadUser(DBUser.self, forKey: .user) ?? nil
    }
    
    /// signIn에 성공하면 True, 실패하면 False를 Return
    func signInGoogle(favoriteMoviesManager: FavoriteMoviesManager) async -> Bool {
        do {
            let helper = SignInGoogleHelper()
            let tokens = try await helper.signIn()
            let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(credentials: tokens)

            try await createUser(authDataResult: authDataResult)
            updateCurrentUser()

            loadLocalFavoriteMovies(favoriteMoviesManager: favoriteMoviesManager )
            return true
        } catch {
            Logger.auth.error("Failed To SignIn Google: \(error)")
            return false
        }
    }

    private func loadLocalFavoriteMovies(favoriteMoviesManager: FavoriteMoviesManager) {
        favoriteMoviesManager.loadLocalFavoriteMovies(userId: user?.userId ?? "")
    }

    private func createUser(authDataResult: AuthDataResultModel) async throws {
        let user = DBUser(auth: authDataResult)

        // 구글로그인 시 날짜 값 때문에 Firestore에 유저 Document가 덮어쓰기 된다. ( Email 로그인은 덮어쓰기 x )
        // 유저가 값이 있는 경우 덮어쓰지 않도록 서버DB의 유저 정보 확인
        do {
            try await UserManager.shared.getUser(userId: user.userId)
        } catch {
            try UserManager.shared.createNewUser(user: user)
        }
    }

    /// UserDefaults에 저장된 DBUser 값을 업데이트 합니다.
    private func updateCurrentUser() {
        UserDefaults.standard.saveUser(user, forKey: .user)
    }
}
