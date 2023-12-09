//
//  SettingsViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    func deleteAccount() async throws {
        guard let user = UserDefaults.standard.loadUser(DBUser.self, forKey: .user) else { return }
        try await AuthenticationManager.shared.delete()
        try await UserManager.shared.deleteUser(userId: user.userId)
        UserDefaults.standard.removeObject(forKey: "user")
    }
}
