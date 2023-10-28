//
//  SearchView.swift
//  Movie
//
//  Created by KHJ on 2023/09/28.
//

import SwiftUI
import NukeUI

struct SearchView: View {
    
    @StateObject var serachViewModel = SearchViewModel()
    
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
                    SearchBar(searchText: $searchText)
                        .onSubmit {
                            Task {
                                await serachViewModel.searchMovies(text: searchText)
                            }
                        }
                    
                    // 검색된 영화 스크롤 뷰
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: layout) {
                            ForEach(serachViewModel.searchedMovies) { movie in
                                NavigationLink {
                                    DetailsView(movie: movie)
                                } label: {
                                    PosterView(movie: movie)
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
        SearchView(serachViewModel: SearchViewModel())
            .preferredColorScheme(.dark)
    }
}
