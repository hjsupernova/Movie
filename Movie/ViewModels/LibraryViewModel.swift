//
//  LibraryViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/10/23.
//

import Foundation
import OSLog

@MainActor
class LibraryViewModel: ObservableObject {
    #warning("서버 베이스인 경우에.. 여러 곳에서 데이터를 접근하는 경우... 데이터.. ")
    @Published private(set) var favoriteMovies: [Movie] = []
    /// 사용자가 앱을 받은 후 처음 앱을 키는 경우 userId는 nil
    var userId: String? = UserDefaults.standard.loadUser(DBUser.self, forKey: .user)?.userId ?? nil
    
    // MARK: - Save Data
    
    private var savePath: URL {
        FileManager.documentsDirectory.appendingPathComponent(userId ?? "")
    }
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            favoriteMovies = try JSONDecoder().decode([Movie].self, from: data)
            Logger.fileManager.info("DEBUG: Complete load data from Documents Directory")
        } catch {
            favoriteMovies = []
        }
    }
    #warning("일관성")
    func loadLocalFavoriteMovies(userId: String) {
        do {
            let savePath = FileManager.documentsDirectory.appending(path: userId)
            let data = try Data(contentsOf: savePath)
            favoriteMovies = try JSONDecoder().decode([Movie].self, from: data)
            Logger.fileManager.info("DEBUG: Complete load data from Documents Directory")
        } catch {
            favoriteMovies = []
        }
    }
    func addFavoriteMovies(movie: Movie) async {
        let newFaovriteMovie = movie
        do {
            try await UserManager.shared.addFavoriteMovie(userId: userId ?? "", movie: newFaovriteMovie)
        } catch {
            Logger.firestore.error("DEBUG: Failed to upload data to firestore")
        }
        favoriteMovies.append(newFaovriteMovie)
        saveFavoriteMovies()
    }
    func deleteFavoriteMovies(movie: Movie) async {
        if let index = favoriteMovies.firstIndex(where: { moive in
            moive == movie
        }) {
            do {
                try await UserManager.shared.removeFavoriteMovie(userId: userId ?? "", movie: movie)
            } catch {
                Logger.firestore.error("DEBUG: Failed to upload data to firestore")
            }
            favoriteMovies.remove(at: index)
            saveFavoriteMovies()
        }
    }
    #warning("함수 네이밍 정확히? ")
    private func saveFavoriteMovies() {
        do {
            let data = try JSONEncoder().encode(favoriteMovies)
            try data.write(to: savePath, options: [.atomic])
            Logger.fileManager.info("DEBUG: Save favorite movie successfully.")
        } catch {
            Logger.fileManager.info("DEBUG: Unable to save data")
        }
    }
    func isFavorite(movie: Movie) -> Bool {
        return favoriteMovies.contains { $0.id == movie.id }
    }
}
