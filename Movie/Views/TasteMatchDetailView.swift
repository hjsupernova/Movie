//
//  TasteMatchDetailView.swift
//  Movie
//
//  Created by KHJ on 2023/11/23.
//

import SwiftUI

import NukeUI

struct TasteMatchDetailView: View {
    let score: Double
    let movie: Movie?
    var body: some View {
        if let movie = movie {
            LazyImage(url: movie.posterURL) { state in
                if let image = state.image {
                    VStack(spacing: 24) {
                        Text(String(format: "%.0f", score) + "% taste match")
                            .font(.title)
                        image.resizable()
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 375)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        Text("The movie that brings you two together is \"\(movie.title)\"")
                            .multilineTextAlignment(.center)
                            .font(.title2)
                    }
                    .bold()
                }
            }
        }
    }
}

#Preview {
    TasteMatchDetailView(score: 5.53535, movie: .preview)
}
