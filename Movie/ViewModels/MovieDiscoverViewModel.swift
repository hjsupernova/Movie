//
//  MovieDiscoverViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/09/13.
//

import SwiftUI

@MainActor
class MovieDiscoverViewModel: ObservableObject {
    
    @Published var popular: [Movie]  = []
    @Published var upcomings: [Movie] = []
    @Published var searchedMovies: [Movie] = []
    
    static var genreLists: [Genre] = []
    
    static let apiKey = "4516ab9bf50f2aa091aeea5f2f5ca6a5"
    
    let apiClient = APIClient(apiKey: apiKey, baseURL: URL.tmdbAPIBaseURL)
    func loadPopoular() async {
        do {
            popular = try await apiClient.fetchData(url: MoviesEndpoint.popular().url, modelType: Response.self).results
        } catch {
            print("DEBUG: Failed to load popular: \(error)")
        }
    }
    
    func loadUpcomings() async {
        
        do {
            upcomings = try await apiClient.fetchData(url: MoviesEndpoint.upcoming().url, modelType: Response.self).results
            
        } catch {
            print("Error: \(error)")
        }
        
    }
    
    #warning("Region이 API에 안들어가는 이유??")
    func searchMovies(text: String) async {
        do {
            searchedMovies = try await apiClient.fetchData(url: SearchEndpoint.movies(query: text).url, modelType: Response.self).results
        } catch {
            print("Error: \(error)")
        }
        
    }
    
    func getGenreLists() async {
        do {
            MovieDiscoverViewModel.genreLists = try await apiClient.fetchData(url: GenresEndpoint.movie.url, modelType: GenreLists.self).genres
        } catch {
            print("Error: \(error)")
        }
        
    }
}

