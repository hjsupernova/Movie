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
                    //Popular Movies
                    VStack(alignment:.leading) {
                        Text("Popular")
                            .font(.title)
                            .bold()
                        
                        ScrollView(.horizontal,showsIndicators: false) {
                            LazyHStack(spacing: 10) {
                                ForEach(discoverViewModel.popular) { movie in
                                    NavigationLink {
                                        DetailsView(movie: movie)
                                    } label: {
                                        PosterView(movie: movie)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Upcomings 
                    VStack(alignment: .leading) {
                        Text("Upcomings")
                            .font(.title)
                            .bold()
                        ScrollView(.horizontal,showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(discoverViewModel.upcomings) { movie in
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
                                                Text("Error")
                                            } else {
                                                CustomProgressView()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                    }
                    
                }
                .padding()
                
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        .task {
            guard !hasAppeared else { return }
            hasAppeared = true
            await discoverViewModel.loadPopoular()
            await discoverViewModel.loadUpcomings()
            await discoverViewModel.getGenreLists()

        }
        .preferredColorScheme(.dark)
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView(discoverViewModel: DiscoverViewModel())
    }
}
