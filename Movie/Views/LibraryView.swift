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
                                LazyImage(url: movie.posterURL) { state in
                                    if let image = state.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 140, height: 200)
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                    } else if state.error != nil {
                                    } else {
                                        CustomProgressView(width: 140, height: 200)
                                    }
                                }
                                VStack {
                                    HStack {
                                        Spacer()
                                        Button {
                                            Task {
                                                await libraryViewModel.deleteFavoriteMovies(movie: movie)
                                            }
                                        } label: {
                                            Image(systemName: "x.circle")
                                                .foregroundColor(.white)
                                        }
                                        .padding(5)
                                        
                                    }
                                    Spacer()
                                }
                                .frame(width: 140, height: 200)
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
