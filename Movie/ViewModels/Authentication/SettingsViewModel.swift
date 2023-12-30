//
//  SettingsViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import OSLog
import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    func signOut() -> Bool {
        do {
            try AuthenticationManager.shared.signOut()
            return true
        } catch {
            // TODO: Combine으로 에러 처리 하기 + do catch 문은 ViewModel에서 처리 "PassthroughSubject, onReceiveError"
            Logger.auth.error("\(error.localizedDescription)")
            return false
        }
    }

    func deleteAccount() async -> Bool {
        do {
            guard let user = UserDefaults.standard.loadUser(DBUser.self, forKey: .user) else { return false
            }
            try await AuthenticationManager.shared.delete()
            try await UserManager.shared.deleteUser(userId: user.userId)
            UserDefaults.standard.removeObject(forKey: "user")
            return true
        } catch {
            Logger.auth.error("\(error.localizedDescription)")
            return false
        }
    }
}
