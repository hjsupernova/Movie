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
    @Published var showAlert = false
    @Published var errorMsg = ""
    @Published var searchText = ""
    func searchMovies() async {
        do {
            searchedMovies = try await APIClient.shared.fetchData(url: SearchEndpoint.movies(query: searchText).url, modelType: MoviePageableList.self).results
        } catch {
            print("DEBUG: Failed to load searched movies: \(error)")
            showAlert = true
            self.errorMsg = error.localizedDescription
        }
    }
}
