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
    func getFavoriteMovies(email: String) async throws -> [Movie] {
        let favoriteMovies = try await UserManager.shared.getFavoriteMovies(email: email)
        return favoriteMovies
    }
    func findMatchedMovies(friendFavoriteMovies: [Movie]) -> [Movie]? {
        let savePath = FileManager.documentsDirectory.appendingPathComponent("FavoriteMovies")
        do {
            let data = try Data(contentsOf: savePath)
            let favoritesMovies = try JSONDecoder().decode([Movie].self, from: data)
            let myMovieIds = Set(favoritesMovies.map { $0.id } )
            return favoritesMovies.filter { myMovieIds.contains($0.id) }
            
        } catch {
            print(error)
        }
        return nil
    }
}
