//
//  TasteMatchViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/11/20.
//

import Foundation

@MainActor
class TasteMatchViewModel: ObservableObject {
    @Published var email = ""
    @Published var user: DBUser?
    @Published var isVaildEmail = false
    @Published var showingSheet = false
    var myMoviesCount: Double {
        do {
            let savePath = FileManager.documentsDirectory.appendingPathComponent(user?.userId ?? "" )
            let data = try Data(contentsOf: savePath)
            let favoritesMovies = try JSONDecoder().decode([Movie].self, from: data)
            return Double(favoritesMovies.count)
        } catch {
            #warning("로그 찍기로 바꾸기 print")
            print(error)
            return 0
        }
    }
    var score = 0.0
    var matchedMovies: [Movie]? = nil
    init() {
        self.user = UserDefaults.standard.loadUser(DBUser.self, forKey: .user)
    }
    func getFriendFavoriteMovies(email: String) async throws -> [Movie] {
        try await UserManager.shared.getFavoriteMovies(email: email)
    }
    func findMatchedMovies(friendEmail: String) async throws {
        let savePath = FileManager.documentsDirectory.appendingPathComponent(user?.userId ?? "")
        let friendsFavMovies = try await getFriendFavoriteMovies(email: email)
        let data = try Data(contentsOf: savePath)
        let favoritesMovies = try JSONDecoder().decode([Movie].self, from: data)
        let myMovieIds = Set(favoritesMovies.map { $0.id } )
        matchedMovies = friendsFavMovies.filter { myMovieIds.contains($0.id) }
    }
    func calculateTasteMatchPercentage() {
        #warning("연산 프로퍼티는 복잡X, 선언해서 재사용하기.. 접근할 때마다 들어옴")
        let matchedMoviesCount = Double(matchedMovies?.count ?? 0)
        let tasteMatchPercentage = ( matchedMoviesCount / myMoviesCount) * 100
        score = tasteMatchPercentage
        print("My Movies count" + String(myMoviesCount))
        print("Matced Movies count" + String(matchedMoviesCount))
        showingSheet = true
        email = ""
    }
}

// MARK: - Email

extension TasteMatchViewModel {
    func isValidEmailAddr(string: String) {
        if string.wholeMatch(of: /[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}/) == nil {
            isVaildEmail = false
        } else {
            isVaildEmail = true
        }
    }
}
