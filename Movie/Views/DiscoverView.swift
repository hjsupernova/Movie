//
//  ContentView.swift
//  Movie
//
//  Created by KHJ on 2023/09/10.
//

import SwiftUI
import NukeUI
import Nuke


struct DiscoverView: View {

    @StateObject var discoverViewModel = DiscoverViewModel()


    @State private var hasAppeared = false

    var body: some View {
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
               
                VStack {
                    // Popular Movies
                    VStack(alignment:.leading) {
                        PosterListView(title: "Popular", movies: discoverViewModel.popular)
                    }
                    // Upcomings
                    VStack(alignment: .leading) {
                        BackdropListView(title: "Upcomings", movies: discoverViewModel.upcomings)
                    }
                    
                    VStack(alignment:.leading) {
                        PosterListView(title: "Now Playing", movies: discoverViewModel.nowplaying)
                    }
                }
                .padding()
            }
            .navigationTitle("🍿 MOVIE")
            .toolbar {
                NavigationLink {
                    ComparisonView(movies: discoverViewModel.nowplaying)
                } label: {
                    Image(systemName: "square.stack.fill")
                }
            }
        }
        .task {
            guard !hasAppeared else { return }
            hasAppeared = true
            await discoverViewModel.loadDiscoverElements()
        }
        .alert(isPresented: $discoverViewModel.showAlert, content: {
            Alert(title: Text("Error"), message: Text(discoverViewModel.errorMsg))
        })

        .preferredColorScheme(.dark)
    }
}

// MARK: - Subviews
struct BackdropListView: View {
    let title: String
    let movies: [Movie]
    var body: some View {
        Text(title)
            .font(.title2)
            .bold()
        ScrollView(.horizontal,showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(movies) { movie in
                    NavigationLink {
                        DetailsView(movie: movie)
                    } label: {
                        LazyImage(url: movie.backdropURL) { state in
                            if let image = state.image {
                                ZStack(alignment: .leading ) {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .opacity(0.75)
                                        .frame(width: 365, height: 205)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                    VStack(alignment: .leading, spacing: 10) {
                                        Spacer()
                                        Text("\(movie.title)")
                                            .font(.title)
                                            .bold()
                                            .foregroundColor(.white)
                                        Text("\(movie.overview)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .lineLimit(2)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView(discoverViewModel: DiscoverViewModel())
            .tint(.white)
    }
}
