//
//  TextField.swift
//  Movie
//
//  Created by KHJ on 2023/09/29.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            TextField("\(Image(systemName:"magnifyingglass")) Shows, Movies and More", text: $searchText)
                .padding(10)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct CustomSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant("H"))
    }
}
