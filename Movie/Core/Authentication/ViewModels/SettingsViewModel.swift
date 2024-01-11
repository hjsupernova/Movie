//
//  SettingsViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import OSLog
import Foundation

import FirebaseAuth
import FirebaseFirestore

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var alertMsg = ""
    @Published var alertTitle = ""

    func signOut() -> Bool {
        do {
            try AuthenticationManager.shared.signOut()
            return true
        } catch {
            // TODO: Combine으로 에러 처리 하기 + do catch 문은 ViewModel에서 처리 "PassthroughSubject, onReceiveError"
            handleSignOutError(error)

            return false
        }
    }
    
    ///  사용자의 계정을 UserDefaults, FirebaseAuth, FirebaseFireStore 3곳에서 삭제합니다.
    /// - Returns: 계정 삭제에 성공시 true 실패시 false를 반환합니다. .
    func deleteAccount() async -> Bool {
        guard let user = UserDefaults.standard.loadUser(DBUser.self, forKey: .user) else {
            return false
        }

        UserDefaults.standard.removeObject(forKey: "user")

        do {
            try await AuthenticationManager.shared.delete()
        } catch {
            handleDeleteAccountAuthError(error)
            return false
        }

        do {
            try await UserManager.shared.deleteUser(userId: user.userId)
        } catch {
            handleDeleteAccountFireStoreError(error)
            return false
        }

        return true
    }

    private func handleDeleteAccountAuthError(_ error: Error) {
        if let error = error as NSError? {
            if let authError = AuthErrorCode.Code(rawValue: error.code) {
                switch authError {
                case .requiresRecentLogin:
                    alertMsg = "This operation requires recent authentication. Please sign in again."
                default:
                    alertMsg = "An unknown authentication error occurred."
                }
            }
        }
        alertTitle = "SignOut Error"
        showAlert = true
        Logger.auth.error("\(error.localizedDescription)")
    }

    private func handleDeleteAccountFireStoreError(_ error: Error) {
        if let error = error as NSError? {
            if let firestoreError = FirestoreErrorCode.Code(rawValue: error.code) {
                switch firestoreError {
                case .unauthenticated:
                    alertMsg = "Authentication error. Please sign in again."
                case .permissionDenied:
                    alertMsg = "You don't have permission to perform this operation."
                case .internal:
                    Logger.firestore.error("Internal error: \(error)")
                    alertMsg = "An unexpected error occurred. Please try again later."
                case .dataLoss:
                    alertMsg = "Critical data loss or corruption. Please contact support."
                case .unavailable:
                    alertMsg = "Service is currently unavailable. Retrying..."
                default:
                    alertMsg = "An unknown error occurred."
                }
            }
        }
        alertTitle = "SignOut Error"
        showAlert = true
        Logger.auth.error("\(error.localizedDescription)")
    }

    private func handleSignOutError(_ error: Error) {
        if let error = error as NSError? {
            if let authError = AuthErrorCode.Code(rawValue: error.code) {
                switch authError {
                case .keychainError:
                    alertMsg = "There was an issue accessing secure storage. Please try signing in again or restarting the app."
                default:
                    alertMsg = "An unknown authentication error occurred."
                }
            }
        }
        alertTitle = "SignOut Error"
        showAlert = true

        Logger.auth.error("\(error)")
    }
}
