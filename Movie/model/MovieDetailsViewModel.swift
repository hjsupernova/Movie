//
//  MovieDetailsViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/09/13.
//

import SwiftUI

@MainActor
class MovieDetailsViewModel: ObservableObject {
    
    
    @Published var movieCredits: MovieCredits?
    @Published var movieCast: [MovieCredits.Cast] = []
    
    @Published var recommendations: [Recommendation] = []

    @Published var favoriteMovies: [Movie]  =  []
    let savePath = FileManager.documentsDirectory.appendingPathComponent("FavoriteMovies")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath )
            favoriteMovies = try JSONDecoder().decode([Movie].self, from: data)
            print("Complete load data from Documents Directory")
        } catch {
            favoriteMovies = []
        }
    }
    
    func addFavoriteMovies(movie: Movie) {
        let newFaovriteMovie = Movie(adult: movie.adult, backdrop_path: movie.backdrop_path, id: movie.id, original_language: movie.original_language, overview: movie.overview, poster_path: movie.poster_path, release_date: movie.release_date, title: movie.title, vote_average: movie.vote_average, genre_ids: movie.genre_ids)
        favoriteMovies.append(newFaovriteMovie)
        
        save()
    }
    //이거 음... 계속 불러오는 게 맞나?

    func save() {
        do {
            let data = try JSONEncoder().encode(favoriteMovies)
            try data.write(to: savePath, options: [.atomic])
            print("Save complete")
        } catch {
            print("Unable to save data")
        }
    }
    
    func getMovieCredits(for movieID: Int) async {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let decoder = JSONDecoder()
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData = try decoder.decode(MovieCredits.self, from: data)
            self.movieCredits = decodedData
            self.movieCast = decodedData.cast
            
                print("Get Movie Credits")
            
        } catch {
            
        }
    }
    
    func getRecommendations(for movieID: Int) async {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/recommendations?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let decoder = JSONDecoder()
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData = try decoder.decode(RecommendationsResponses.self, from: data)
            recommendations = decodedData.results
            
        } catch {
            
        }
        
        
    }
    
}


struct MovieCredits: Decodable {
    let id: Int
    let cast: [Cast]
    
    struct Cast: Decodable, Identifiable {
        let id: Int
        let name: String
        let profile_path: String?
        
        var photoUrl: URL? {
            let baseURL = URL(string: "https://image.tmdb.org/t/p/w185")
            return baseURL?.appending(path: profile_path ?? "")
        }
        
        
        static var preview: Cast {
            return Cast(id: 3, name: "Harrison Ford", profile_path: "/5M7oN3sznp99hWYQ9sX0xheswWX.jpg")
        }
    }
}

struct RecommendationsResponses: Decodable {
    let results: [Recommendation]
}

struct Recommendation: Decodable, Identifiable {
    let title: String
    let id: Int
    let poster_path: String?
    
    
    var posterUrl: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")
        return baseURL?.appending(path: poster_path ?? "")
    }
    
}


extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
