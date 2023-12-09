//
//  ContentView.swift
//  Movie
//
//  Created by KHJ on 2023/09/10.
//

import SwiftUI

import Nuke
import NukeUI

struct DiscoverView: View {
    @StateObject var discoverViewModel = DiscoverViewModel()
    @State private var hasAppeared = false
    @Binding var showSignInView: Bool
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    // Popular
                    VStack(alignment: .leading) {
                        PosterListView(title: "Popular", movies: discoverViewModel.popular)
                    }
                    // Upcomings
                    VStack(alignment: .leading) {
                        BackdropListView(title: "Upcomings", movies: discoverViewModel.upcomings)
                    }
                    // Now Playing
                    VStack(alignment: .leading) {
                        PosterListView(title: "Now Playing", movies: discoverViewModel.nowplaying)
                    }
                }
                .padding()
            }
            .navigationTitle("🍿 MOVIE")
            .toolbar {
                NavigationLink {
                    SettingsView(showSingInView: $showSignInView)
                } label: {
                    Image(systemName: "person.crop.circle")
                }
                NavigationLink {
                    TasteMatchView()
                } label: {
                    Image(systemName: "person.2.fill")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView(discoverViewModel: DiscoverViewModel(), showSignInView: .constant(false))
            .tint(.white)
    }
}
