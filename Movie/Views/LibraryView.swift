//
//  LibraryView.swift
//  Movie
//
//  Created by KHJ on 2023/10/02.
//

import SwiftUI
import NukeUI
struct LibraryView: View {
    
    @EnvironmentObject var libraryViewModel: LibraryViewModel
    let layout = [
        GridItem(.adaptive(minimum: 300, maximum: 500)),
        GridItem(.adaptive(minimum: 300, maximum: 500))
    ]
    

    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: layout) {
                    ForEach(libraryViewModel.favoriteMovies) { movie in
                        NavigationLink {
                            DetailsView(movie: movie)
                        } label: {
                            ZStack {
                                PosterView(movie: movie)
                                VStack {
                                    HStack {
                                        Spacer()
                                        Button {
                                            libraryViewModel.deleteFavoriteMovies(movie: movie)
                                        } label: {
                                            Image(systemName: "x.circle")
                                                .foregroundColor(.white)
                                        }
                                        
                                    }
                                    Spacer()
                                }
                            }
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
        LibraryView()
            .preferredColorScheme(.dark)
            .environmentObject(LibraryViewModel())
    }
}
