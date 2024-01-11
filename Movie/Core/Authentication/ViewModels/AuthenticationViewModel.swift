//
//  AuthenticationViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import Foundation
import OSLog

import FirebaseFirestore
import GoogleSignIn
import GoogleSignInSwift


@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var alertMsg = ""
    @Published var alertTitle = ""

    /// SignInGoogleHelper을 통해 사용자가 구글 로그인을 할 수 있도록 합니다.
    /// - Parameter favoriteMoviesManager: 로그인한 사용자의 좋아요한 영화 목록을 로컬에서 가져오기 위해 필요한 매니저 입니다.
    /// - Returns: 로그인 성공 시 true, 실패 시 false를 반환합니다.
    func signInGoogle(favoriteMoviesManager: FavoriteMoviesManager) async -> Bool {
        let tokens: GoogleSignInResult
        let authDataResult: AuthDataResultModel

        do {
            let helper = SignInGoogleHelper()
            tokens = try await helper.signIn()
            authDataResult = try await AuthenticationManager.shared.signInWithGoogle(credentials: tokens)

        } catch {
            handleGoogleSignInError(error)
            return false
        }

        do {
            try await createUser(authDataResult: authDataResult)
            let user = DBUser(auth: authDataResult)
            updateCurrentUser(user: user)
            loadLocalFavoriteMovies(favoriteMoviesManager: favoriteMoviesManager, user: user)

            return true
        } catch {
            handleGoogleSignInFirestoreError(error)

            return false
        }
    }

    private func loadLocalFavoriteMovies(favoriteMoviesManager: FavoriteMoviesManager, user: DBUser) {
        favoriteMoviesManager.userId = user.userId
        favoriteMoviesManager.loadLocalFavoriteMovies(userId: user.userId)
    }
    
    /// 구글 로그인을 통해 FirebaseFirestore에  DBUser값을 저장합니다.
    /// - Parameter authDataResult: DBUser 객체를 만들기 위해 인증 결과값을 가져옵니다.
    /// 먼저 FirebaseFirestore에 유저값이 이미 있는 경우엔 그 유저 값을 가져오고 없는 경우에만 새로운 User를 저장합니다.
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
    private func updateCurrentUser(user: DBUser) {
        UserDefaults.standard.saveUser(user, forKey: .user)
    }

    private func handleGoogleSignInError(_ error: Error) {
        if let error = error as NSError? {
            if let googleSignInError = GIDSignInError.Code(rawValue: error.code) {
                switch googleSignInError {
                case .canceled:
                    return
                case .unknown:
                    alertMsg = "An unknown error occurred during Google Sign-In. Please try again."
                case .keychain:
                    alertMsg = "There was an issue accessing secure storage. Please try signing in again or restarting the app."
                case .hasNoAuthInKeychain:
                    alertMsg = "No authentication information found in the keychain. Please sign in again."
                case .EMM:
                    alertMsg = "Error in EMM. Please try again."
                case .scopesAlreadyGranted:
                    alertMsg = "Google Sign-In scopes are already granted."
                case .mismatchWithCurrentUser:
                    alertMsg = "There is a mismatch with the current user during Google Sign-In. Please sign in again."
                default:
                    alertMsg = "An unknown error occurred during Google Sign-In. Please try again."
                }
            }
        }
        alertTitle = "SignIn Google Error"
        showAlert = true
        Logger.auth.error("\(error.localizedDescription)")
    }

    private func handleGoogleSignInFirestoreError(_ error: Error) {
        if let error = error as NSError? {
            if let firestoreError = FirestoreErrorCode.Code(rawValue: error.code) {
                switch firestoreError {
                case .notFound:
                    alertMsg = "The requested document was not found. Please check the user ID and try again."
                case .permissionDenied:
                    alertMsg = "You don't have permission to perform this operation. Please contact support for assistance."
                case .invalidArgument:
                    alertMsg = "Invalid argument provided. Please check the user data and try again."
                case .resourceExhausted:
                    alertMsg = "Resource exhaustion. Please try again later or contact support."
                default:
                    // Handle other Firestore errors
                    alertMsg = "An unknown error occurred during Firestore operation. Please try again."
                }
            }
        }

        alertTitle = "SignIn Google Error"
        showAlert = true
        Logger.auth.error("\(error.localizedDescription)")
    }
}
