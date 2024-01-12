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
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    PosterListView(title: "Popular", movies: discoverViewModel.popular)
                    BackdropListView(title: "Upcomings", movies: discoverViewModel.upcomings)
                    PosterListView(title: "Now Playing", movies: discoverViewModel.nowplaying)
                }
                .padding()
            }
            .navigationTitle("🍿 MOVIE")
            .toolbar {
                settingsViewLink
                tasteMatchViewLink
            }
        }
        .task {
            await discoverViewModel.loadDiscoverElements()
        }
        .alert(isPresented: $discoverViewModel.showAlert, content: {
            Alert(title: Text("Error"), message: Text(discoverViewModel.errorMsg))
        })
        .preferredColorScheme(.dark)
    }

    // MARK: -

    private var settingsViewLink: some View {
        NavigationLink {
            SettingsView(showSingInView: $showSignInView)
        } label: {
            Image(systemName: "person.crop.circle")
        }
    }

    private var tasteMatchViewLink: some View {
        NavigationLink {
            TasteMatchView()
        } label: {
            Image(systemName: "person.2.fill")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView(discoverViewModel: DiscoverViewModel(), showSignInView: .constant(false))
    }
}
