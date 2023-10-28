//
//  SearchViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/10/23.
//

import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var searchedMovies: [Movie] = []
    let apiClient = APIClient(apiKey: DetailsViewModel.apiKey, baseURL: URL.tmdbAPIBaseURL)

    #warning("Region이 API에 안들어가는 이유??")
    func searchMovies(text: String) async {
        do {
            searchedMovies = try await apiClient.fetchData(url: SearchEndpoint.movies(query: text).url, modelType: Response.self).results
        } catch {
            print("Error: \(error)")
        }
        
    }
}
