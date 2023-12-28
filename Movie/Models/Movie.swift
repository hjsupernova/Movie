//
//  Movie.swift
//  Movie
//
//  Created by KHJ on 2023/09/11.
//

import Foundation

import URL

struct Movie: Codable, Identifiable, Equatable {
    let adult: Bool
    let backdropPath: String?
    let id: Int
    let originalLanguage: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let title: String
    let voteAverage: Double
    let genreIds: [Int]
    let homepage: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case adult
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case genreIds = "genre_ids"
        case homepage
    }
    
    var posterURL: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w500/")
        return baseURL?.appending(path: posterPath ?? "")
    }
    var backdropURL: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w1280/")
        return baseURL?.appending(path: backdropPath ?? "")
    }
    var genres: String {
        let genrelists: GenreList = Bundle.main.decode("Genrelists")
        var genreNames = [String]()
        for id in genreIds {
            if let genre = genrelists.genres.first(where: { $0.id == id }) {
                let genreName = genre.name
                genreNames.append(genreName)
            }
        }
        let strGenreNames = genreNames.joined(separator: " ")
        return strGenreNames
    }
    var formattedVoteAverage: String {
        let formattedVoteAverage = String(format: "%.1f", voteAverage)
        return formattedVoteAverage
    }
    var homepageURL: URL {
        URL(string: homepage ?? "https://www.themoviedb.org/movie/\(id)") ?? #URL( "https://www.themoviedb.org/movie/")
    }
    static var preview: Movie {
        return Movie(adult: false,
                     backdropPath: "/8pjWz2lt29KyVGoq1mXYu6Br7dE.jpg",
                     id: 615656,
                     originalLanguage: "en",
                     // swiftlint:disable line_length
                     overview: "An exploratory dive into the deepest depths of the ocean of a daring research team spirals into chaos when a malevolent mining operation threatens their mission and forces them into a high-stakes battle for survival.",
                     posterPath: "/4m1Au3YkjqsxF8iwQy0fPYSxE0h.jpg",
                     releaseDate: "2023-08-02",
                     title: "Meg 2: The Trench",
                     voteAverage: 7.0,
                     genreIds: [28, 12],
                     homepage: "https://www.themeg.movie"
        )
    }
    static var preview2: Movie {
        return Movie(adult: false,
                     backdropPath: "//t5zCBSB5xMDKcDqe91qahCOUYVV.jpg",
                     id: 507089,
                     originalLanguage: "en",
                     overview: "Recently fired and desperate for work, a troubled young man named Mike agrees to take a position as a night security guard at an abandoned theme restaurant: Freddy Fazbear's Pizzeria. But he soon discovers that nothing at Freddy's is what it seems.",
                     posterPath: "/A4j8S6moJS2zNtRR8oWF08gRnL5.jpg",
                     releaseDate: "2023-08-02",
                     title: "Five",
                     voteAverage: 7.0,
                     genreIds: [28, 12],
                     homepage: "https://www.themeg.movie"
        )
    }
    static var preview3: Movie {
        return Movie(adult: false,
                     backdropPath: "//t5zCBSB5xMDKcDqe91qahCOUYVV.jpg",
                     id: 1234234,
                     originalLanguage: "en",
                     overview: "Recently fired and desperate for work, a troubled young man named Mike agrees to take a position as a night security guard at an abandoned theme restaurant: Freddy Fazbear's Pizzeria. But he soon discovers that nothing at Freddy's is what it seems.",
                     posterPath: "aQPeznSu7XDTrrdCtT5eLiu52Yu.jpg",
                     releaseDate: "2023-08-02",
                     title: "SA",
                     voteAverage: 7.0,
                     genreIds: [28, 12],
                     homepage: "https://www.themeg.movie"
        )
    }
}
