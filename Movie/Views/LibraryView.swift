//
//  LibraryView.swift
//  Movie
//
//  Created by KHJ on 2023/10/02.
//

import SwiftUI
import NukeUI
struct LibraryView: View {
    
    @ObservedObject var detailsViewModel: MovieDetailsViewModel
    let layout = [
        GridItem(.adaptive(minimum: 300, maximum: 500)),
        GridItem(.adaptive(minimum: 300, maximum: 500))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: layout) {
                    ForEach(detailsViewModel.favoriteMovies) { movie in
                        NavigationLink {
                            Text("\(movie.title)")
                        } label: {
                            PosterView(movie: movie)
                        }
                    }
                }
            }
            .navigationTitle("Library") 
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(detailsViewModel: MovieDetailsViewModel())
            .preferredColorScheme(.dark)
    }
}
