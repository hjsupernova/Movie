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
    @Published var hasMoreResults = false
    private var currentPage = 1
    private var isSearching = false
    
    func loadMore() async {
        currentPage += 1
        await searchMovies()
    }
    
    func searchMovies() async {
        guard !isSearching else { return }
        isSearching = true
        do {
            let moviePage = try await APIClient.shared.fetchData(url: SearchEndpoint.movies(query: searchText, page: currentPage).url, modelType: MoviePageableList.self)
            searchedMovies.append(contentsOf: moviePage.results)
            hasMoreResults = moviePage.page < moviePage.total_pages
        } catch {
            print("DEBUG: Failed to load searched movies: \(error)")
            showAlert = true
            self.errorMsg = error.localizedDescription
        }
        isSearching = false
    }
}
