//
//  LibraryViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/10/23.
//

import Foundation

@MainActor
class LibraryViewModel: ObservableObject {
    @Published var favoriteMovies: [Movie] = []
    var userId: String? = UserDefaults.standard.loadUser(DBUser.self, forKey: .user)?.userId ?? nil
    //MARK: - Save Data
    var savePath: URL {
        FileManager.documentsDirectory.appendingPathComponent(userId ?? "")
    }

    init() {
        do {
            let data = try Data(contentsOf: savePath )
            favoriteMovies = try JSONDecoder().decode([Movie].self, from: data)
            print("DEBUG: Complete load data from Documents Directory")
        } catch {
            favoriteMovies = []
        }
    }
    
    func getLocalFavMovies(userId: String) {
        do {
            let savePath = FileManager.documentsDirectory.appending(path: userId)
            let data = try Data(contentsOf: savePath )
            favoriteMovies = try JSONDecoder().decode([Movie].self, from: data)
            print("DEBUG: Complete load data from Documents Directory")
        } catch {
            favoriteMovies = []
        }
    }
    
    func addFavoriteMovies(movie: Movie) async  {
        let newFaovriteMovie = movie
        do {
            try await UserManager.shared.addFavoriteMovie(userId: userId ?? "", movie: newFaovriteMovie)
        } catch {
            print("DEBUG: Failed to upload data to firestore")
        }
        favoriteMovies.append(newFaovriteMovie)
        save()
    }
    
    func deleteFavoriteMovies(movie: Movie) async {
        if let index = favoriteMovies.firstIndex(where: { moive in
            moive == movie
        }) {
            favoriteMovies.remove(at: index)
            do {
                try await UserManager.shared.removeFavoriteMovie(userId: userId ?? "", movie: movie)
            } catch {
                print("DEBUG: Failed to upload data to firestore")
            }
            
            save()
        }
    }
    
    // 데이터를 외부에서 수정하고 저장하는 걸 방지
    private func save() {
        do {
            let data = try JSONEncoder().encode(favoriteMovies)
            try data.write(to: savePath, options: [.atomic])
            print("DEBUG: Save favorite movie successfully.")
        } catch {
            print("DEBUG: Unable to save data")
        }
    }
    
    func isFavorite(movie: Movie) -> Bool {
        return favoriteMovies.contains { $0.id == movie.id}
    }
}
