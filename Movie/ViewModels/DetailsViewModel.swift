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
    
//MARK: - Network
        
    func getMovieCredits(for movieID: Int) async -> Credits? {
        do {
            print("DEBUG: Movie credits loaded successfully.")

            return try await APIClient.shared.fetchData(url: MoviesEndpoint.credits(movieID: movieID).url, modelType: Credits.self)
//            credits = decodedData
//            cast = decodedData.cast
        } catch {
            
            print("DEBUG: Failed to load Movie Credits: \(error)")
            #warning("nil 값이 넘어오면.. 처리할 방법 해결.. 사실 nil 값이 넘어올 일이 없긴 없음.. 에러 핸들링을 찾아보자..")
            return nil
            
        }
    }
    
    func getRecommendations(for movieID: Int) async -> [Movie] {
        do {
            print("DEBUG: Recommendations loaded successfully.")
            return try await APIClient.shared.fetchData(url: MoviesEndpoint.recommendations(movieID: movieID).url, modelType: MoviePageableList.self).results
        } catch {
            print("DEBUG: Failed to load recommendations: \(error)")
            return []
        }
    }
    func loadDetailsElements(for movieID: Int) async {
        async let credits = getMovieCredits(for: movieID)
        async let recommendations = getRecommendations(for: movieID)
        
        self.recommendations = await recommendations
        self.credits = await credits
        self.cast = await credits!.cast
    }

}


