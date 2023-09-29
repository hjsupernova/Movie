//
//  ContentView.swift
//  Movie
//
//  Created by KHJ on 2023/09/10.
//

import SwiftUI
import NukeUI
import Nuke

struct CustomProgress : View {
    
    var body: some View {
        ProgressView()
            .frame(width: 140, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
}
struct CustomImage: View {
    
    let image: Image
    init(image: Image) {
        self.image = image
    }
    var body: some View {
        
        image
            .resizable()
            .scaledToFill()
            .frame(width: 140, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        
    }
    
}


struct ContentView: View {
    
    @StateObject var viewModel = MovieDiscoverViewModel()
    
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
                                ForEach(viewModel.popular) { movie in
                                    NavigationLink {
                                        DetailView(movie: movie)
                                    } label: {
                                        LazyImage(url: movie.posterURL) { state in
                                            if let image = state.image {
                                                CustomImage(image: image)
                                            } else if state.error != nil {
                                                Text("Error")
                                            } else {
                                                CustomProgress()
                                            }
                                        }
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
                                ForEach(viewModel.upcomings) { movie in
                                    NavigationLink {
#warning("영화 정보 사이트 브라우저 띄우기")
                                        DetailView(movie: movie)
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
                                                CustomProgress()
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button() {

                    } label: {
                        Label("List", systemImage: "line.3.horizontal")
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SearchView(viewModel: viewModel)
                    } label: {
                        Label("Search", systemImage: "magnifyingglass")
                            .foregroundColor(.white)
                    }
                }
                
            }
            
        }
        .task {
            await viewModel.loadPopoular()
            await viewModel.loadUpcomings()
            
        }
        .preferredColorScheme(.dark)
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
