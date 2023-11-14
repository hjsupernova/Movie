//
//  Movie.swift
//  Movie
//
//  Created by KHJ on 2023/09/11.
//

import Foundation

struct Movie: Codable, Identifiable, Equatable {
    let adult: Bool
    let backdrop_path: String?
    let id: Int
    let original_language: String
    let overview: String
    let poster_path: String?
    let release_date, title: String
    let vote_average: Double
    let genre_ids: [Int]
    let homepage: String?
    
    var posterURL: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w500/")
        return baseURL?.appending(path: poster_path ?? "")
    }
    var backdropURL: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w1280/")
        return baseURL?.appending(path: backdrop_path ?? "")
    
    }
    var genres: String? {
        let genrelists: GenreList = Bundle.main.decode("Genrelists")
        var genreNames = [String]()
        for id in genre_ids {
            if let genre = genrelists.genres.first(where: { $0.id == id }) {
                let genreName = genre.name
                genreNames.append(genreName)
            }
        }
        let strGenreNames = genreNames.joined(separator: " ")
        return strGenreNames
    }
    var formattedVoteAverage: String {
        let formattedVoteAverage = String(format: "%.1f", vote_average)
        return formattedVoteAverage
    }
    var homepageURL: URL {
        URL(string: homepage ?? "https://www.themoviedb.org/movie/\(id)")!
    }
    static var preview: Movie {
        return Movie(adult: false,
                     backdrop_path: "/8pjWz2lt29KyVGoq1mXYu6Br7dE.jpg",
                     id: 615656,
                     original_language: "en",
                     overview: "An exploratory dive into the deepest depths of the ocean of a daring research team spirals into chaos when a malevolent mining operation threatens their mission and forces them into a high-stakes battle for survival.",
                     poster_path: "/4m1Au3YkjqsxF8iwQy0fPYSxE0h.jpg",
                     release_date: "2023-08-02",
                     title: "Meg 2: The Trench",
                     vote_average: 7.0,
                     genre_ids: [28,12], homepage: "https://www.themeg.movie"
        )
    }
    static var preview2: Movie {
        return Movie(adult: false,
                     backdrop_path: "//t5zCBSB5xMDKcDqe91qahCOUYVV.jpg",
                     id: 507089,
                     original_language: "en",
                     overview: "Recently fired and desperate for work, a troubled young man named Mike agrees to take a position as a night security guard at an abandoned theme restaurant: Freddy Fazbear's Pizzeria. But he soon discovers that nothing at Freddy's is what it seems.",
                     poster_path: "/A4j8S6moJS2zNtRR8oWF08gRnL5.jpg",
                     release_date: "2023-08-02",
                     title: "Five",
                     vote_average: 7.0,
                     genre_ids: [28,12], homepage: "https://www.themeg.movie"
        )
    }
    static var preview3: Movie {
        return Movie(adult: false,
                     backdrop_path: "//t5zCBSB5xMDKcDqe91qahCOUYVV.jpg",
                     id: 1234234,
                     original_language: "en",
                     overview: "Recently fired and desperate for work, a troubled young man named Mike agrees to take a position as a night security guard at an abandoned theme restaurant: Freddy Fazbear's Pizzeria. But he soon discovers that nothing at Freddy's is what it seems.",
                     poster_path: "aQPeznSu7XDTrrdCtT5eLiu52Yu.jpg",
                     release_date: "2023-08-02",
                     title: "SA",
                     vote_average: 7.0,
                     genre_ids: [28,12], homepage: "https://www.themeg.movie"
        )
    }
}
