//
//  PosterView.swift
//  Movie
//
//  Created by KHJ on 2023/10/02.
//

import SwiftUI
import NukeUI

struct PosterView: View {
    
    let movie: Movie
    init(movie: Movie) {
        self.movie = movie
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LazyImage(url: movie.posterURL) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else if state.error != nil {
                } else {
                    CustomProgressView(width: 140, height: 240)
                }
            }
            .refelction(offsetY: 0)
            VStack(alignment: .leading, spacing: 0) {
                Text(movie.title)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                HStack() {
                    Image("tmdbLogo")
                        .resizable()
                        .frame(width: 20, height: 8)
                    Text(String(format: "%.1f", movie.vote_average))
                        .font(.caption2)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(4)
            .padding(.leading, 4)
            .foregroundStyle(.white)
        }
        .frame(width: 140, height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct PosterView_Previews: PreviewProvider {
    static var previews: some View {
        PosterView(movie: .preview)
    }
}
