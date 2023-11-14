//
//  DiscoverViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/09/13.
//

import SwiftUI

@MainActor
class DiscoverViewModel: ObservableObject {
    
    @Published var popular: [Movie]  = []
    @Published var upcomings: [Movie] = []
    @Published var nowplaying: [Movie] = []
    @Published var showAlert = false
    @Published var errorMsg = "" 
    static var genreLists: [Genre] = []
    
    
    func loadPopoular() async throws -> [Movie] {
        print("DEBUG: Start to load popular")
        return try await APIClient.shared.fetchData(url: MoviesEndpoint.popular().url, modelType: MoviePageableList.self).results
    }
    func loadUpcomings() async throws -> [Movie] {
        print("DEBUG: Start to load upcomings")
        return try await APIClient.shared.fetchData(url: MoviesEndpoint.upcoming().url, modelType: MoviePageableList.self).results
    }
    func loadNowplaying() async throws -> [Movie] {
        print("DEBUG: Start to load nowplaying")
        return try await APIClient.shared.fetchData(url: MoviesEndpoint.nowplaying().url, modelType: MoviePageableList.self).results
    }
    func getGenreLists() async throws -> [Genre] {
        print("DEBUG: Start to load genre lists")
        return try await APIClient.shared.fetchData(url: GenresEndpoint.movie.url, modelType: GenreList.self).genres
    }
    // 비동기로 loadPopular, loadUpcomings, getGenreLists가 실행된다 (동시에)
    func loadDiscoverElements() async {
        do {
            async let popular = loadPopoular()
            async let upcomings = loadUpcomings()
            async let nowplaying = loadNowplaying()
            async let genreLists = getGenreLists()
            // 여기 await은 변수가 오기 전까지 오래걸릴 수 있다는 얘기
            // 하지만 위에 async let으로 동기적으로 처리하기 때문에 여기서 줄 바이 줄로 기다리지는 않음.
            self.popular = try await popular
            self.upcomings = try await upcomings
            self.nowplaying = try await nowplaying
            DiscoverViewModel.genreLists = try await genreLists
        } catch {
            print("DEBUG: Failed to load Discover Elements: \(error)")
            showAlert = true
            self.errorMsg = error.localizedDescription
        }
    }
}
