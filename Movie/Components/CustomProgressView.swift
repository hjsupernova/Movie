//
//  CustomProgressView.swift
//  Movie
//
//  Created by KHJ on 2023/09/30.
//

import SwiftUI

struct CustomProgressView: View {
    let width: CGFloat
    let height: CGFloat
    var body: some View {
        ProgressView()
            .frame(width: width, height: height)
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView(width: 100, height: 100)
    }
}
