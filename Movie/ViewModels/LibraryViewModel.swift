//
//  LibraryViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/10/23.
//

import Foundation

class LibraryViewModel: ObservableObject {
    
    @Published var favoriteMovies: [Movie]  =  []
    //MARK: - Save Data
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("FavoriteMovies")
    
    //이거 음... 계속 불러오는 게 맞나?
    init() {
        do {
            let data = try Data(contentsOf: savePath )
            favoriteMovies = try JSONDecoder().decode([Movie].self, from: data)
            print("DEBUG: Complete load data from Documents Directory")
        } catch {
            favoriteMovies = []
        }
    }
    
    func addFavoriteMovies(movie: Movie) {
        let newFaovriteMovie = movie
        
        favoriteMovies.append(newFaovriteMovie)
        save()
    }
    
    func deleteFavoriteMovies(movie: Movie) {
        if let index = favoriteMovies.firstIndex(where: { moive in
            moive == movie
        }) {
            favoriteMovies.remove(at: index)
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
