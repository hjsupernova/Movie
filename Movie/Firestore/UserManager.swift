//
//  UserManager.swift
//  Movie
//
//  Created by KHJ on 2023/11/19.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    let userId: String
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let favoriteMoives: [Movie]?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.photoUrl = auth.photoURL
        self.dateCreated = Date()
        self.favoriteMoives = nil
    }
}
    
final class UserManager {
    static let shared = UserManager()
    private init() {}
    private let userCollection = Firestore.firestore().collection("users")
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    func createNewUser(user: DBUser) throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: encoder)
    }
    @discardableResult
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self, decoder: decoder)
    }
    func deleteUser(userId: String) async throws {
        try await userDocument(userId: userId).delete()
    }
    func addFavoriteMovie(userId: String, movie: Movie) async throws {
        guard let data = try? encoder.encode(movie) else  {
            throw URLError(.badURL)
        }
        let dict: [String: Any] = [
            "favorite_movies": FieldValue.arrayUnion([data])
        ]
        try await userDocument(userId: userId).updateData(dict)
    }
    func removeFavoriteMovie(userId: String, movie: Movie) async throws {
        guard let data = try? encoder.encode(movie) else  {
            throw URLError(.badURL)
        }
        let dict: [String: Any] = [
            "favorite_movies": FieldValue.arrayRemove([data])
        ]
        try await userDocument(userId: userId).updateData(dict)
    }
    func getFavoriteMovies(email: String) async throws -> [Movie] {
        let query = userCollection.whereField("email", isEqualTo: email)
        let snapshot = try await query.getDocuments()
        guard !snapshot.documents.isEmpty else { return [] }
        let document = snapshot.documents[0]
        let userData = document.data()
        let movieData = userData["favorite_movies"] as? [[String:Any]]
        if let movieData = movieData {
            do {
                let favoriteMovies = try Firestore.Decoder().decode([Movie].self, from: movieData)
                return favoriteMovies
            } catch {
                print(error)
            }
        }
        return []
    }
}
