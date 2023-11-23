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
            LazyImage(url: movie.posterURL ?? URL(string: ""))
            Text(String(score))
        }
    }
}

#Preview {
    TasteMatchDetailView(score: 5, movie: .preview)
}
