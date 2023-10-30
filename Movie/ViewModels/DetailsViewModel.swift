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
    @Published var castList: [Credits.Cast] = []
    @Published var recommendations: [Movie] = []
    
//MARK: - Network
        
    func getMovieCredits(for movieID: Int) async {
        
        do {
            let decodedData = try await APIClient.shared.fetchData(url: MoviesEndpoint.credits(movieID: movieID).url, modelType: Credits.self)
            credits = decodedData
            castList = decodedData.cast
            print("DEBUG: Movie credits loaded successfully.")
        } catch {
            print("DEBUG: Failed to load Movie Credits: \(error)")
        }
        
    }
    
    func getRecommendations(for movieID: Int) async {   
        
        do {
            recommendations = try await APIClient.shared.fetchData(url: MoviesEndpoint.recommendations(movieID: movieID).url, modelType: Response.self).results
            print("DEBUG: Recommendations loaded successfully.")

        } catch {
            print("DEBUG: Failed to load recommendations: \(error)")

        }
        
    }

}


