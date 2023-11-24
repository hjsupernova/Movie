//
//  TasteMatchViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/11/20.
//

import Foundation

@MainActor
class TasteMatchViewModel: ObservableObject {
    @Published var email = ""
    @Published var user: DBUser?
    @Published var isVaildEmail = false
    @Published var showingSheet = false
    var myMoviesCount: Double {
        do {
            let savePath = FileManager.documentsDirectory.appendingPathComponent("FavoriteMovies")
            let data = try Data(contentsOf: savePath)
            let favoritesMovies = try JSONDecoder().decode([Movie].self, from: data)
            return Double(favoritesMovies.count)
        } catch {
            print(error)
            return 0
        }
    }
    var score = 0.0
    var matchedMovies: [Movie]? = nil
    init(email: String = "") {
        self.email = email
        do {
            guard let data = UserDefaults.standard.data(forKey: "user") else {
                throw URLError(.badURL)
            }
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(DBUser.self, from: data)
            self.user = decodedData
            print(user?.photoUrl ?? "No photo")
            print(user?.userId ?? "No Id")
            print(user?.dateCreated ?? "No date")
        } catch {
         print(error)
        }
    }
    func getFriendFavoriteMovies(email: String) async throws -> [Movie] {
        try await UserManager.shared.getFavoriteMovies(email: email)
    }
    func findMatchedMovies(friendEmail: String) async throws {
        let savePath = FileManager.documentsDirectory.appendingPathComponent("FavoriteMovies")
        let friendsFavMovies = try await getFriendFavoriteMovies(email: email)
        let data = try Data(contentsOf: savePath)
        let favoritesMovies = try JSONDecoder().decode([Movie].self, from: data)
        let myMovieIds = Set(favoritesMovies.map { $0.id } )
        matchedMovies = friendsFavMovies.filter { myMovieIds.contains($0.id) }
    }
    func calculateTasteMatchPercentage() {
        let matchedMoviesCount = Double(matchedMovies?.count ?? 0)
        let tasteMatchPercentage = ( matchedMoviesCount / myMoviesCount) * 100
        score = tasteMatchPercentage
        print("My Movies count" + String(myMoviesCount))
        print("Matced Movies count" + String(matchedMoviesCount))
        showingSheet = true
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
