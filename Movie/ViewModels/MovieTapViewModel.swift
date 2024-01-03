//
//  MovieTapViewModel.swift
//  Movie
//
//  Created by KHJ on 2024/01/03.
//

import Foundation

@MainActor
final class MovieTabViewModel: ObservableObject {
    @Published var selectedTap: Views = .discover
    @Published var showSignInView: Bool = false

    func loadCurrentUser() async {
        do {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try await UserManager.shared.getUser(userId: authDataResult.uid)
        } catch {
            showSignInView = true
        }
    }
}
