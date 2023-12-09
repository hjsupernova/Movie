//
//  SearchViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/10/23.
//

import Foundation
import OSLog

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchedMovies: [Movie] = []
    @Published var showAlert = false
    @Published var errorMsg = ""
    @Published var searchText = ""
    private var currentPage = 1
    private var isSearching = false
    func fetchMoreSearchedMovies() async {
        currentPage += 1
        guard !isSearching else { return }
        isSearching = true
        do {
            let moviePage = try await APIClient.shared.fetchData(
                url: SearchEndpoint.movies(query: searchText, page: currentPage).url,
                modelType: MoviePageableList.self
            )
            searchedMovies.append(contentsOf: moviePage.results)
        } catch {
            Logger.network.info("DEBUG: Failed to load searched movies: \(error)")
            showAlert = true
            errorMsg = error.localizedDescription
        }
        isSearching = false
    }
    func fetchSearchedMoviesFirstTime() async {
        do {
            currentPage = 1
            let moviePage = try await APIClient.shared.fetchData(
                url: SearchEndpoint.movies(query: searchText, page: currentPage).url,
                modelType: MoviePageableList.self
            )
            searchedMovies = moviePage.results
        } catch {
            Logger.network.info("DEBUG: Failed to load searched movies: \(error)")
            showAlert = true
            errorMsg = error.localizedDescription
        }
    }
}
