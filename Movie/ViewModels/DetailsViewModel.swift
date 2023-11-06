//
//  DetailsViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/09/13.
//

import SwiftUI

@MainActor
class DetailsViewModel: ObservableObject {
    
    
    @Published var credits: Credits?
    @Published var cast: [CastMember] = []
    @Published var recommendations: [Movie] = []
    @Published var showAlert = false
    @Published var errorMsg = ""
    
//MARK: - Network
        
    func getMovieCredits(for movieID: Int) async throws -> Credits? {

            print("DEBUG: Movie credits loaded successfully.")

            return try await APIClient.shared.fetchData(url: MoviesEndpoint.credits(movieID: movieID).url, modelType: Credits.self)

    }
    
    func getRecommendations(for movieID: Int) async throws -> [Movie] {
            print("DEBUG: Recommendations loaded successfully.")
            return try await APIClient.shared.fetchData(url: MoviesEndpoint.recommendations(movieID: movieID).url, modelType: MoviePageableList.self).results
    }
    func loadDetailsElements(for movieID: Int) async {
        do {
            async let credits = getMovieCredits(for: movieID)
            async let recommendations = getRecommendations(for: movieID)
            
            self.recommendations = try await recommendations
            self.credits = try await credits
            self.cast = try await credits!.cast
        } catch {
            print("DEBUG: Failed to load Details Elements: \(error)")
            showAlert = true
            errorMsg = error.localizedDescription
        }
    }

}


