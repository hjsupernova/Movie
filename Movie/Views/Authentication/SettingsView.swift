//
//  SettingsView.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSingInView: Bool
    var body: some View {
        List {
            Button("Sign out") {
                do {
                    try viewModel.signOut()
                    showSingInView = true
                } catch {
                    print(error)
                }
            }
            Button("Delete account", role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteAccount()
                        showSingInView = true
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView(showSingInView: .constant(false))
}
