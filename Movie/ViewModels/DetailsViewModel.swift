//
//  DetailsViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/09/13.
//

import OSLog
import SwiftUI

@MainActor
class DetailsViewModel: ObservableObject {
    @Published var credits: Credits?
    @Published var cast: [CastMember] = []
    @Published var recommendations: [Movie] = []
    @Published var showAlert = false
    @Published var errorMsg = ""
    
    // MARK: - Network
    
    func fetchMovieCredits(for movieID: Int) async throws -> Credits? {
        return try await APIClient.shared.fetchData(url: MoviesEndpoint.credits(movieID: movieID).url,
                                                    modelType: Credits.self)
    }
    func fetchRecommendations(for movieID: Int) async throws -> [Movie] {
        return try await APIClient.shared.fetchData(url: MoviesEndpoint.recommendations(movieID: movieID).url,
                                                    modelType: MoviePageableList.self).results
    }
    func fetchDetailsElements(for movieID: Int) async {
        do {
            async let credits = fetchMovieCredits(for: movieID)
            async let recommendations = fetchRecommendations(for: movieID)

            self.recommendations = try await recommendations
            self.credits = try await credits
            cast = try await credits!.cast
        } catch {
            Logger.network.info("DEBUG: Failed to load Details Elements: \(error)")
            showAlert = true
            errorMsg = error.localizedDescription
        }
    }
}
