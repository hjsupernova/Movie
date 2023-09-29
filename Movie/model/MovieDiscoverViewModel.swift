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
    
    static let apiKey = "4516ab9bf50f2aa091aeea5f2f5ca6a5"
    
    func loadPopoular() async {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(MovieDiscoverViewModel.apiKey)")!
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
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=ko-KR&page=1&region=kr&release_date.gte=2023-09-28&release_date.lte=2023-10-05&sort_by=popularity.desc&with_release_type=3&api_key=\(MovieDiscoverViewModel.apiKey)")!
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
        #error("띄어쓰기, 한글 등 예방하기 + TapView로 전환")
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(text)&include_adult=false&language=en-US&page=1&api_key=\(MovieDiscoverViewModel.apiKey)")!
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
    
}


