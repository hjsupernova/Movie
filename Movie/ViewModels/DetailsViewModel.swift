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
    @Published private(set) var credits: Credits?
    @Published private(set) var cast: [CastMember] = []
    @Published private(set) var recommendations: [Movie] = []
    @Published var showAlert = false
    @Published private(set) var errorMsg = ""
    @Published private(set) var lineLimit = 3

    private var hasAppeared: Bool = false
    
    func increaseLineLimit() {
        withAnimation {
            lineLimit = 10
        }
    }

    func shareMovie(homepageURL: URL) {
        let activityVC = UIActivityViewController(activityItems: [homepageURL], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }

    private func fetchMovieCredits(for movieID: Int) async throws -> Credits? {
        return try await APIClient.shared.fetchData(url: MoviesEndpoint.credits(movieID: movieID).url,
                                                    modelType: Credits.self)
    }

    private func fetchRecommendations(for movieID: Int) async throws -> [Movie] {
        return try await APIClient.shared.fetchData(url: MoviesEndpoint.recommendations(movieID: movieID).url,
                                                    modelType: MoviePageableList.self).results
    }

    func fetchDetailsElements(for movieID: Int) async {
        guard !hasAppeared else { return }
        hasAppeared = true

        do {
            async let credits = fetchMovieCredits(for: movieID)
            async let recommendations = fetchRecommendations(for: movieID)

            self.recommendations = try await recommendations
            self.credits = try await credits
            guard let credits = try await credits else { return  }
            cast = credits.cast
        } catch {
            Logger.network.info("DEBUG: Failed to load Details Elements: \(error)")
            errorMsg = error.localizedDescription
            showAlert = true
        }
    }
}
