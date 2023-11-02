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
    static var genreLists: [Genre] = []

    
    func loadPopoular() async -> [Movie] {
        do {
            print("DEBUG: Start to load popular")

            return try await APIClient.shared.fetchData(url: MoviesEndpoint.popular().url, modelType: Response.self).results

        } catch {
            print("DEBUG: Failed to load popular: \(error)")
            return []
        }
    }
    func loadUpcomings() async -> [Movie] {
        do {
            print("DEBUG: Start to load upcomings")
            return try await APIClient.shared.fetchData(url: MoviesEndpoint.upcoming().url, modelType: Response.self).results
        } catch {
            print("DEBUG: Failed to load upcomings: \(error)")
            return []
        }
    }
    func getGenreLists() async -> [Genre] {
        do {
            print("DEBUG: Start to load genre lists")
            return try await APIClient.shared.fetchData(url: GenresEndpoint.movie.url, modelType: GenreLists.self).genres
        } catch {
            print("Error: \(error)")
            return []
        }
    }
    // 비동기로 loadPopular, loadUpcomings, getGenreLists가 실행된다 (동시에)
    func loadDiscoverElements() async {
        async let upcomings = loadUpcomings()
        async let popular = loadPopoular()
        async let genreLists = getGenreLists()
        // 여기 await은 변수가 오기 전까지 오래걸릴 수 있다는 얘기
        // 하지만 위에 async let으로 동기적으로 처리하기 때문에 여기서 줄 바이 줄로 기다리지는 않음.
        self.popular = await popular
        self.upcomings = await upcomings
        DiscoverViewModel.genreLists = await genreLists
    }
}
