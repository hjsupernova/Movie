//
//  BackdropListView.swift
//  Movie
//
//  Created by KHJ on 2023/11/27.
//

import SwiftUI

import NukeUI

struct BackdropListView: View {
    let title: String
    let movies: [Movie]
    var body: some View {
        HStack {
            Text(title)
                .font(.title2.bold())
            NavigationLink {
                ComparisonView(movies: movies)
            } label: {
                Image(systemName: "square.stack.fill")
            }
        }
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(movies) { movie in
                    NavigationLink {
                        DetailsView(movie: movie)
                    } label: {
                        LazyImage(url: movie.backdropURL) { state in
                            if let image = state.image {
                                ZStack(alignment: .leading) {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .opacity(0.75)
                                        .frame(width: 365, height: 205)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                    VStack(alignment: .leading, spacing: 10) {
                                        Spacer()
                                        Text("\(movie.title)")
                                            .font(.title.bold())
                                            .multilineTextAlignment(.leading)
                                            .foregroundColor(.white)
                                        Text("\(movie.overview)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding(5)
                                    .frame(width: 365, height: 205)
                                }
                            } else if state.error != nil {
                            } else {
                                CustomProgressView(width: 365, height: 205)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    BackdropListView(title: "Upcomings", movies: [Movie.preview, Movie.preview2])
}
