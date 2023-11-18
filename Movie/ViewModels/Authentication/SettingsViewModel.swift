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
        try await AuthenticationManager.shared.delete()
    }
}
