//
//  PosterListView.swift
//  Movie
//
//  Created by KHJ on 2023/11/04.
//

import SwiftUI

struct PosterListView: View {
    let title: String
    let movies: [Movie]
    var body: some View {
        Text(title)
            .font(.title2)
            .bold()
        ScrollView(.horizontal,showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(movies) { movie in
                    NavigationLink {
                        DetailsView(movie: movie)
                    } label: {
                        PosterView(movie: movie)
                    }
                }
            }
        }
    }
}

//#Preview {
//    PosterListView()
//}
