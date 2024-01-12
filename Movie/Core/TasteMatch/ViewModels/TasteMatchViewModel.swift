//
//  TasteMatchViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/11/20.
//

import Foundation
import OSLog

import FirebaseFirestore
import Firebase

@MainActor
class TasteMatchViewModel: ObservableObject {
    @Published var email = ""
    @Published private(set) var user: DBUser?
    @Published private(set) var isVaildEmail = false
    @Published var showingSheet = false

    @Published var showAlert = false
    @Published var alertMsg = ""
    @Published var alertTitle = ""

    private func loadMyFavoriteMoives() throws -> [Movie] {
        let savePath = FileManager.documentsDirectory.appendingPathComponent(user?.userId ?? "")
        let data = try Data(contentsOf: savePath)
        let favoritesMovies = try JSONDecoder().decode([Movie].self, from: data)
        return favoritesMovies
    }

    private func myMoviesCount() throws -> Double {
        let favoritesMovies = try loadMyFavoriteMoives()
        return Double(favoritesMovies.count)
    }

    private(set) var score = 0.0
    private(set) var matchedMovies: [Movie]? = nil

    init() {
        self.user = UserDefaults.standard.loadUser(DBUser.self, forKey: .user)
    }

    /// 비교할 다른 사용자의 좋아요한 영화를 불러옵니다.
    /// - Parameter email: 비교할 사용자의 email
    /// - Returns: 비교할 사용자의 좋아요한 영화 목록
    private func fetchFriendFavoriteMovies(with email: String) async throws -> [Movie] {
        try await UserManager.shared.getFavoriteMovies(email: email)
    }


    /// 다른 사용자의 좋아요한 영화 목록과 내 좋아요한 영화 목록의 공통 영화 목록을 반환합니다.
    /// - Parameter friendFavoriteMovies: 비교할 다른 사용자의 좋아요한 영화 목록
    /// - Returns: 다른 사용자와 현 유저의 공통 좋아요한 영화 목록
    private func findMatchedMovies(with friendFavoriteMovies: [Movie]) async throws -> [Movie] {
        let myFavoritesMovies = try loadMyFavoriteMoives()
        let myMovieIds = Set(myFavoritesMovies.map { $0.id } )

        return friendFavoriteMovies.filter { myMovieIds.contains($0.id) }
    }

    private func calculateTasteMatchPercentage() throws {
#warning("연산 프로퍼티는 복잡X, 선언해서 재사용하기.. 접근할 때마다 들어옴")
        let myMoviesCount = try myMoviesCount()
        let matchedMoviesCount = Double(matchedMovies?.count ?? 0)
        let tasteMatchPercentage = ( matchedMoviesCount / myMoviesCount) * 100
        score = tasteMatchPercentage
        showingSheet = true
        email = ""
    }
    
    func compareMovieTaste(friendEmail: String) async {
        do {
            let friendFavoriteMovies = try await fetchFriendFavoriteMovies(with: friendEmail)
            matchedMovies = try await findMatchedMovies(with: friendFavoriteMovies)
            try calculateTasteMatchPercentage()
        } catch {
            handleTasteMatchFirestoreError(error)
            Logger.firestore.error("Failed to compare movie taste \(error)")
        }

    }

    private func handleTasteMatchFirestoreError(_ error: Error) {
        if let error = error as NSError? {
            if let firestoreError = FirestoreErrorCode.Code(rawValue: error.code) {
                switch firestoreError {
                case .notFound:
                    alertMsg = "The requested document was not found. Please check the user ID and try again."
                case .permissionDenied:
                    alertMsg = "You don't have permission to perform this operation. Please contact support for assistance."
                case .invalidArgument:
                    alertMsg = "Invalid argument provided. Please check the user data and try again."
                case .resourceExhausted:
                    alertMsg = "Resource exhaustion. Please try again later or contact support."
                default:
                    // Handle other Firestore errors
                    alertMsg = "An unknown error occurred during Firestore operation. Please try again."
                }
            }
        }
        showAlert = true
        alertTitle = "Compare Movie Error"
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
