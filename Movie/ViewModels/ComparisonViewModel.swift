//
//  ComparisonViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/11/14.
//

import Foundation
import SwiftUI

// TODO: ViewModel 전부 MainActor
class ComparisonViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    
    init(movies: [Movie]) {
        self.movies = movies
    }
    var hasSingleMovie: Bool {
        movies.count == 1
    }
    var currentMovieTitle: String {
        movies.last?.title ?? ""
    }
    #warning("인덱스!!")
    var lastMovieHomepageURL: URL {
        movies[0].homepageURL
    }
    var lastMoviePosterURL: URL? {
        movies.first?.posterURL
    }
    func moveLastMoiveToTop() {
        let savedMovie = movies.remove(at: movies.count - 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.movies.insert(savedMovie, at: 0)
        }
    }
    func removeLastMovie() {
        movies.remove(at: movies.count - 1)
    }
    func getIndex(of movie: Movie) -> Int {
        movies.firstIndex(of: movie) ?? -1
    }
}
