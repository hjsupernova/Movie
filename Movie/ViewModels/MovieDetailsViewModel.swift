//
//  MovieDetailsViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/09/13.
//

import SwiftUI

@MainActor
class MovieDetailsViewModel: ObservableObject {
    
    
    @Published var credits: Credits?
    @Published var castList: [Credits.Cast] = []
    @Published var recommendations: [Recommendation] = []
    @Published var favoriteMovies: [Movie]  =  []
    
    
//MARK: - Network
    static let apiKey = "4516ab9bf50f2aa091aeea5f2f5ca6a5"
    
    let apiClient = APIClient(apiKey: apiKey, baseURL: URL.tmdbAPIBaseURL)
    
    func getMovieCredits(for movieID: Int) async {
        
        do {
            let decodedData = try await apiClient.fetchData(url: MoviesEndpoint.credits(movieID: movieID).url, modelType: Credits.self)
            credits = decodedData
            castList = decodedData.cast
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func getRecommendations(for movieID: Int) async {
        
        do {
            recommendations = try await apiClient.fetchData(url: MoviesEndpoint.recommendations(movieID: movieID).url, modelType: RecommendationsResponses.self).results
        } catch {
            print("DEBUG: Failed to load recommendations: \(error)")

        }
        
    }
    
    
    

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
        let newFaovriteMovie = Movie(adult: movie.adult, backdrop_path: movie.backdrop_path, id: movie.id, original_language: movie.original_language, overview: movie.overview, poster_path: movie.poster_path, release_date: movie.release_date, title: movie.title, vote_average: movie.vote_average, genre_ids: movie.genre_ids)
        favoriteMovies.append(newFaovriteMovie)
        
        save()
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(favoriteMovies)
            try data.write(to: savePath, options: [.atomic])
            print("Save complete")
        } catch {
            print("Unable to save data")
        }
    }
    
 
    
}


