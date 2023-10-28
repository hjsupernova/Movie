//
//  DetailsView.swift
//  Movie
//
//  Created by KHJ on 2023/09/12.
//

import SwiftUI
import NukeUI



struct DetailsView: View {
    
    var movie: Movie
    @StateObject var detailsViewModel = DetailsViewModel()
    @EnvironmentObject var libraryViewModel: LibraryViewModel
    
    // TabView에서 왔다갔다 할 때도 이게 network ( .task) 발생 방지.
    @State private var hasAppeared = false
    var body: some View {
        ZStack {
            //BackDrop
            VStack  {
                LazyImage(url: movie.backdropURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                    } else if phase.error != nil {
                        Text("Error")
                    } else {
                        ProgressView()
                    }
                }
                .ignoresSafeArea()
                .opacity(0.5)
                Spacer()
            }
            ScrollView(showsIndicators: false) {
                //Title, Poster, Details
                VStack(alignment:.leading) {
                    
                    // Poster, Details
                    HStack(alignment:.top) {
                        PosterView(movie: movie)
                        VStack(alignment: .leading) {
                            Text("\(movie.genres!)")
                                .font(.headline.bold())
                            HStack {
                                Text("\(movie.vote_average.formatted())")
                                    .frame(width:35, height: 35)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .strokeBorder(.yellow, lineWidth: 1)
                                    )
                                Text(movie.original_language.uppercased())
                                    .frame(width:35, height: 35)
                                    .clipShape(Circle())
                                    .overlay(
                                        Rectangle()
                                            .strokeBorder(.green, lineWidth: 1)
                                    )
                                if libraryViewModel.favoriteMovies.contains(where: {$0.id == movie.id}) {
                                    Button {
                                        libraryViewModel.deleteFavoriteMovies(movie: movie)
                                    } label: {
                                        Image(systemName: "x.circle")
                                            .foregroundColor(.white)
                                            .font(.title)
                                    }
                                } else {
                                    Button {
                                        libraryViewModel.addFavoriteMovies(movie: movie)
                                    } label: {
                                        Image(systemName: "plus.circle")
                                            .foregroundColor(.white)
                                            .font(.title)
                                    }
                                }
                                
                            }
                            Text(movie.release_date)
                                .font(.caption)
                            
                        }
                    }
                    
                    Text("Overview")
                        .font(.title.bold())
                    
                    Text(movie.overview)
                    
                    // Cast View
                    Text("Cast")
                        .font(.title.bold())
                        .padding(.top)
                    
                    ScrollView(.horizontal,showsIndicators: false) {
                        LazyHStack {
                            ForEach(detailsViewModel.castList) { cast in
                                CastView(cast: cast)
                            }
                        }
                    }
                    
                    //Recommencations View
                    Text("Recommendations")
                        .font(.title.bold())
                        .padding(.top)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        LazyHStack {
                            ForEach(detailsViewModel.recommendations) { movie in
                                NavigationLink {
                                    DetailsView(movie: movie, detailsViewModel: detailsViewModel)
                                } label: {
                                    PosterView(movie: Movie(adult: false, backdrop_path: "", id: movie.id, original_language: "", overview: "", poster_path: movie.poster_path ?? "", release_date: "", title: movie.title, vote_average: 5.5, genre_ids: []))
                                    
                                }
                                
                            }
                        }
                        
                    }
                    
                }
                .padding()
            }
            .task {
                guard !hasAppeared else { return }
                hasAppeared = true
                await detailsViewModel.getMovieCredits(for: movie.id)
                await detailsViewModel.getRecommendations(for: movie.id)
                
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.large)
        
    }
    
    
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(movie: .preview, detailsViewModel: DetailsViewModel())
            .preferredColorScheme(.dark)
    }
}


