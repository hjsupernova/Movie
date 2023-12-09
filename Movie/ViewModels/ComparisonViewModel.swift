//
//  ComparisonViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/11/14.
//

import Foundation
import SwiftUI

class ComparisonViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var showingSheet = false
    @Published var selectedMovie: Movie?
    
    init(movies: [Movie]) {
        self.movies = movies
    }
    
    var hasSingleMovie: Bool {
        movies.count == 1
    }
    
    var currentMovieTitle: String {
        movies[movies.count - 1].title
    }
    #warning("인덱스!!")
    var lastMovieHomepageURL: URL {
        movies[0].homepageURL
    }
    var lastMoviePosterURL: URL? {
        movies[0].posterURL
    }
    
    func saveMoive() {
        
        let savedMovie = movies.remove(at: movies.count - 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.movies.insert(savedMovie, at: 0)
        }
    }
    
    func removeMovie() {
        movies.remove(at: movies.count - 1)
    }
    
    func getIndex(of movie: Movie) -> Int {
        movies.firstIndex(of: movie) ?? -1
    }
}
