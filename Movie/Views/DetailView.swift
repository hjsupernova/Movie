//
//  DetailView.swift
//  Movie
//
//  Created by KHJ on 2023/09/12.
//

import SwiftUI
import NukeUI



struct DetailView: View {
    
    @ObservedObject var detailsViewModel: MovieDetailsViewModel
    @State var hasAppeared = false
    var movie: Movie
    
    var body: some View {
        NavigationView {
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
                ScrollView {
                    //Title, Poster, Details
                    VStack(alignment:.leading) {
                        //Title
                        HStack {
                            Text(movie.title)
                                .font(.title.bold())
                                .lineLimit(1)
                            Spacer()
                            
                            Button {
                                detailsViewModel.addFavoriteMovies(movie: movie)
                                
                            } label: {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.white)
                                    .font(.title.bold())
                            }
                        }
                        // Poster, Details
                        HStack(alignment:.top) {
                            PosterView(movie: movie)
                            VStack(alignment: .leading) {
                                Text("\(movie.genres!)")
                                    .font(.headline.bold())
                                    .onAppear {

                                    }
                                
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
                        
                        ScrollView(.horizontal) {
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
                        
                        ScrollView(.horizontal){
                            LazyHStack {
                                ForEach(detailsViewModel.recommendations) { recommendation in
                                    PosterView(movie: Movie(adult: false, backdrop_path: "", id: recommendation.id, original_language: "", overview: "", poster_path: recommendation.poster_path ?? "", release_date: "", title: recommendation.title, vote_average: 5.5, genre_ids: []))
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
            
        }
    }
    
    
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(detailsViewModel: MovieDetailsViewModel(), movie: .preview)
            .preferredColorScheme(.dark)
    }
}


