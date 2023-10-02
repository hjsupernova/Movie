//
//  SearchView.swift
//  Movie
//
//  Created by KHJ on 2023/09/28.
//

import SwiftUI
import NukeUI

struct SearchView: View {
    
    @ObservedObject var viewModel: MovieDiscoverViewModel
    let layout = [
        GridItem(.adaptive(minimum: 300, maximum: 500)),
        GridItem(.adaptive(minimum: 300, maximum: 500))
                         
    ]
    
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    //NavBar
                    HStack {
                        Text("Search")
                            .font(.largeTitle.bold())
                        Spacer()
                        
                        NavigationLink {
                            Text("Person View")
                        } label: {
                            Image(systemName: "person.crop.circle")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }

                    }
                    CustomSearchBar(searchText: $searchText)
                        .onSubmit {
                            Task {
                                await viewModel.searchMovies(text: searchText)
                            }
                        }
                    
                    // 검색된 영화 스크롤 뷰
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: layout) {
                            ForEach(viewModel.searchedMovies) { movie in
                                NavigationLink {
                                    Text("\(movie.title)")
                                } label: {
                                    LazyImage(url: movie.posterURL) { state in
                                        if let image = state.image {
                                            CustomImage(image: image)
                                        } else if state.error   != nil {
                                            Text("Error")
                                        } else {
                                            CustomProgressView()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    
                }
                .padding()

                
            }
            
        }
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: MovieDiscoverViewModel())
            .preferredColorScheme(.dark)
    }
}
