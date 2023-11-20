//
//  TasteMatchView.swift
//  Movie
//
//  Created by KHJ on 2023/11/20.
//

import SwiftUI

struct TasteMatchView: View {
    @StateObject var tasteMatchViewModel = TasteMatchViewModel()
    @State private var matchedMovies: [Movie]? = []
    var body: some View {
        VStack {
            Image(systemName: "person")
            Text("Compare your music taste with a friend")
            TextField("Enter your friend's email address", text: $tasteMatchViewModel.email)
                .textInputAutocapitalization(.never)
            Button("Compare") {
                
                Task {
                    do {
                        let friendFavoriteMovies = try await tasteMatchViewModel.getFavoriteMovies(email: tasteMatchViewModel.email)
                        matchedMovies = tasteMatchViewModel.findMatchedMovies(friendFavoriteMovies: friendFavoriteMovies)
                    } catch {
                        print("Failed to fetch fmovies.")
                    }
                        
                }
                // Fetch friend's data
                // Find matches
                // show sheets
            }
            if matchedMovies?.count == 0 {
                
            } else {
                Text(matchedMovies?[0].title ?? "")
            }
        }
        .navigationTitle("Taste Match")
    }
}

#Preview {
    TasteMatchView()
}
