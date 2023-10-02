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
        LazyImage(url: movie.posterURL) { state in
            if let image = state.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } else if state.error != nil {
                Text("Error")
            } else {
                CustomProgressView()
            }
        }
    }
}


struct PosterView_Previews: PreviewProvider {
    static var previews: some View {
        PosterView(movie: .preview)
    }
}
