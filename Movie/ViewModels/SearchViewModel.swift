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
    func searchMovies(text: String) async {
        do {
            searchedMovies = try await APIClient.shared.fetchData(url: SearchEndpoint.movies(query: text).url, modelType: MoviePageableList.self).results
        } catch {
            print("DEBUG: Failed to searched movies: \(error)")
        }
        
    }
}
