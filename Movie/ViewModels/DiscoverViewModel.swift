//
//  DiscoverViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/09/13.
//

import SwiftUI

@MainActor
class DiscoverViewModel: ObservableObject {
    
    @Published var popular: [Movie]  = []
    @Published var upcomings: [Movie] = []    
    static var genreLists: [Genre] = []

    let apiClient = APIClient(apiKey: Bundle.main.apiKey, baseURL: URL.tmdbAPIBaseURL)
    
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
            print("DEBUG: Failed to load upcomings: \(error)")
        }
        
    }
    

    
    func getGenreLists() async {
        do {
            DiscoverViewModel.genreLists = try await apiClient.fetchData(url: GenresEndpoint.movie.url, modelType: GenreLists.self).genres
        } catch {
            print("Error: \(error)")
        }
        
    }
}

