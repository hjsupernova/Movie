//
//  MovieDiscoverViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/09/13.
//

import SwiftUI

@MainActor
class MovieDiscoverViewModel: ObservableObject {
    
    @Published var popular: [Movie]  = []
    @Published var upcomings: [Movie] = []
    @Published var searchedMovies: [Movie] = []
    
    static var genreLists: [Genre] = []
    
    static let apiKey = "4516ab9bf50f2aa091aeea5f2f5ca6a5"
    
    func loadPopoular() async {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?region=US&api_key=\(MovieDiscoverViewModel.apiKey)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let decoder = JSONDecoder()
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData = try decoder.decode(Response.self, from: data)
            popular = decodedData.results
            print("Load Pouplar Moives")
        } catch {
            print("Error \(error)")
        }
        
    }
    func loadUpcomings() async {
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?language=en-US&region=US&sort_by=popularity.desc&api_key=\(MovieDiscoverViewModel.apiKey)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let decoder = JSONDecoder()
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData = try decoder.decode(Response.self, from: data)
            upcomings = decodedData.results
            print("Load Upcoming movies")
        } catch {
            print("Error \(error)")
        }
        
    }
    func searchMovies(text: String) async {
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(text)&language=en-US&page=1&api_key=\(MovieDiscoverViewModel.apiKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let decoder = JSONDecoder()
        do {

            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData = try decoder.decode(Response.self, from: data)
            searchedMovies = decodedData.results
            print("Search Movie")
        } catch {
            print("Error \(error)")
        }
        
    }
    func getGenreLists() async {
        let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(MovieDiscoverViewModel.apiKey)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let decoder = JSONDecoder()
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData = try decoder.decode(GenreLists.self, from: data)
            MovieDiscoverViewModel.genreLists = decodedData.genres
            print("Get genre lists")
        } catch {
            print("Error \(error)")
        }
        
    }
}


