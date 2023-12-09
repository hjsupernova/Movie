//
//  DiscoverViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/09/13.
//

import OSLog
import SwiftUI

@MainActor
class DiscoverViewModel: ObservableObject {
    @Published var popular: [Movie] = []
    @Published var upcomings: [Movie] = []
    @Published var nowplaying: [Movie] = []
    @Published var showAlert = false
    @Published var errorMsg = ""
    static var genreLists: [Genre] = []
    func loadPopoular() async throws -> [Movie] {
        Logger.network.info("DEBUG: Start to load popular")
        return try await APIClient.shared.fetchData(url: MoviesEndpoint.popular().url,
                                                    modelType: MoviePageableList.self).results
    }
    func loadUpcomings() async throws -> [Movie] {
        Logger.network.info("DEBUG: Start to load upcomings")
        return try await APIClient.shared.fetchData(url: MoviesEndpoint.upcoming().url,
                                                    modelType: MoviePageableList.self).results
    }
    func loadNowplaying() async throws -> [Movie] {
        Logger.network.info("DEBUG: Start to load nowplaying")
        return try await APIClient.shared.fetchData(url: MoviesEndpoint.nowplaying().url,
                                                    modelType: MoviePageableList.self).results
    }
    func getGenreLists() async throws -> [Genre] {
        Logger.network.info("DEBUG: Start to load genre lists")
        return try await APIClient.shared.fetchData(url: GenresEndpoint.movie.url,
                                                    modelType: GenreList.self).genres
    }
    /// 비동기, 동시적으로 DiscoverView에 필요한 데이터들을 불러온다.
    func loadDiscoverElements() async {
        do {
            async let popular = loadPopoular()
            async let upcomings = loadUpcomings()
            async let nowplaying = loadNowplaying()
            async let genreLists = getGenreLists()
            // 여기 await은 변수가 오기 전까지 오래 걸릴 수도 있다는 것을 의미
            // 하지만 위에 함수들이 동시적으로 처리되기 때문에(async let) 여기서 줄 바이 줄로 기다리지는 않음
            self.popular = try await popular
            self.upcomings = try await upcomings
            self.nowplaying = try await nowplaying
            DiscoverViewModel.genreLists = try await genreLists
        } catch {
            Logger.network.error("DEBUG: Failed to load Discover Elements: \(error)")
            showAlert = true
            errorMsg = error.localizedDescription
        }
    }
}
