//
//  TasteMatchViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/11/20.
//

import Foundation
import OSLog

@MainActor
class TasteMatchViewModel: ObservableObject {
    @Published var email = ""
    @Published private(set) var user: DBUser?
    @Published private(set) var isVaildEmail = false
    @Published var showingSheet = false
    @Published var showErrorAlert = false
    @Published var errorAlertMessage = ""

    private var myMoviesCount: Double {
        do {
            let savePath = FileManager.documentsDirectory.appendingPathComponent(user?.userId ?? "")
            let data = try Data(contentsOf: savePath)
            let favoritesMovies = try JSONDecoder().decode([Movie].self, from: data)
            return Double(favoritesMovies.count)
        } catch {
            Logger.fileManager.error("\(error)")
            return 0
        }
    }
    private(set) var score = 0.0
    private(set) var matchedMovies: [Movie]? = nil

    init() {
        self.user = UserDefaults.standard.loadUser(DBUser.self, forKey: .user)
    }

    /// 비교할 다른 사용자의 좋아요한 영화를 불러옵니다.
    /// - Parameter email: 비교할 사용자의 email
    /// - Returns: 비교할 사용자의 좋아요한 영화 목록
    private func fetchFriendFavoriteMovies(with email: String) async throws -> [Movie] {
        try await UserManager.shared.getFavoriteMovies(email: email)
    }

    
    /// 다른 사용자의 좋아요한 영화 목록과 내 좋아요한 영화 목록의 공통 영화 목록을 반환합니다.
    /// - Parameter friendFavoriteMovies: 비교할 다른 사용자의 좋아요한 영화 목록
    /// - Returns: 다른 사용자와 현 유저의 공통 좋아요한 영화 목록
    private func findMatchedMovies(with friendFavoriteMovies: [Movie]) async throws -> [Movie] {
        let savePath = FileManager.documentsDirectory.appendingPathComponent(user?.userId ?? "")
        let data = try Data(contentsOf: savePath)
        let myFavoritesMovies = try JSONDecoder().decode([Movie].self, from: data)
        let myMovieIds = Set(myFavoritesMovies.map { $0.id } )

        return friendFavoriteMovies.filter { myMovieIds.contains($0.id) }
    }

    private func calculateTasteMatchPercentage() {
        #warning("연산 프로퍼티는 복잡X, 선언해서 재사용하기.. 접근할 때마다 들어옴")
        let matchedMoviesCount = Double(matchedMovies?.count ?? 0)
        let tasteMatchPercentage = ( matchedMoviesCount / myMoviesCount) * 100
        score = tasteMatchPercentage
        showingSheet = true
        email = ""
    }
    
    func compareMovieTaste(friendEmail: String) async {
        do {
            let friendFavoriteMovies = try await fetchFriendFavoriteMovies(with: friendEmail)
            matchedMovies = try await findMatchedMovies(with: friendFavoriteMovies)
            calculateTasteMatchPercentage()
        } catch {
            errorAlertMessage = error.localizedDescription
            showErrorAlert = true

            Logger.firestore.error("Failed to compare movie taste \(error)")
        }
    }
}

// MARK: - Email

extension TasteMatchViewModel {
    func isValidEmailAddr(string: String) {
        if string.wholeMatch(of: /[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}/) == nil {
            isVaildEmail = false
        } else {
            isVaildEmail = true
        }
    }
}
