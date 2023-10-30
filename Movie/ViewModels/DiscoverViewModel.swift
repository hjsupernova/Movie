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

    
    func loadPopoular() async {
        do {
            popular = try await APIClient.shared.fetchData(url: MoviesEndpoint.popular().url, modelType: Response.self).results
        } catch {
            print("DEBUG: Failed to load popular: \(error)")
        }
    }
    
    func loadUpcomings() async {
        
        do {
            upcomings = try await APIClient.shared.fetchData(url: MoviesEndpoint.upcoming().url, modelType: Response.self).results
            
        } catch {
            print("DEBUG: Failed to load upcomings: \(error)")
        }
        
    }
    

    
    func getGenreLists() async {
        do {
            DiscoverViewModel.genreLists = try await APIClient.shared.fetchData(url: GenresEndpoint.movie.url, modelType: GenreLists.self).genres
        } catch {
            print("Error: \(error)")
        }
        
    }
}

