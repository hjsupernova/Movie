//
//  FavoriteMovies.swift
//  Movie
//
//  Created by KHJ on 2023/12/30.
//

import Foundation
import OSLog

@MainActor
class FavoriteMoviesManager: ObservableObject {
    // TODO: 데이터를 폰, 컴퓨터에서 동시에 접근하는 경우 생각해보기.
    @Published private(set) var favoriteMovies: [Movie] = []

    var userId: String? = UserDefaults.standard.loadUser(DBUser.self, forKey: .user)?.userId ?? nil

    init() {
        loadLocalFavoriteMovies(userId: userId ?? "")
    }

    func loadLocalFavoriteMovies(userId: String) {
        do {
            let savePath = FileManager.documentsDirectory.appending(path: userId)
            let data = try Data(contentsOf: savePath)

            favoriteMovies = try JSONDecoder().decode([Movie].self, from: data)

            Logger.fileManager.info("Complete load data from Documents Directory")
        } catch {
            favoriteMovies = []
        }
    }

    func addFavoriteMovies(movie: Movie) async {
        do {
            try await UserManager.shared.addFavoriteMovie(userId: userId ?? "", movie: movie)
        } catch {
            Logger.firestore.error("Failed to upload data to firestore")
        }

        favoriteMovies.append(movie)

        saveFavoriteMoviesLocally()
    }

    func deleteFavoriteMovies(movie: Movie) async {
        guard let index = favoriteMovies.firstIndex(of: movie) else { return }

        do {
            try await UserManager.shared.removeFavoriteMovie(userId: userId ?? "", movie: movie)

            favoriteMovies.remove(at: index)

            saveFavoriteMoviesLocally()
        } catch {
            Logger.firestore.error("DEBUG: Failed to upload data to firestore")
        }
    }

    private func saveFavoriteMoviesLocally() {
        do {
            let savePath = FileManager.documentsDirectory.appending(path: userId ?? "")
            let data = try JSONEncoder().encode(favoriteMovies)

            try data.write(to: savePath)

            Logger.fileManager.info("Save favorite movie successfully.")
        } catch {
            Logger.fileManager.info("DEBUG: Unable to save data")
        }
    }

    func isFavorite(movie: Movie) -> Bool {
        return favoriteMovies.contains { $0.id == movie.id }
    }

}
