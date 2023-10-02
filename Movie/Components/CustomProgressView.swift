//
//  CustomProgressView.swift
//  Movie
//
//  Created by KHJ on 2023/09/30.
//

import SwiftUI

struct CustomProgressView : View {
    var body: some View {
        ProgressView()
            .frame(width: 140, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView()
    }
}
