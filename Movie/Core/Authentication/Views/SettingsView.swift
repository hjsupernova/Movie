//
//  SettingsView.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var settingViewModel = SettingsViewModel()
    @Binding var showSingInView: Bool
    
    var body: some View {
        List {
            signOutButton
            deleteAccountButton
        }
        .navigationTitle("Settings")
    }

    // MARK: - Computed properties

    private var signOutButton: some View {
        Button("Sign out") {
            showSingInView =  settingViewModel.signOut()
        }
    }

    private var deleteAccountButton: some View {
        Button("Delete account", role: .destructive) {
            Task {
                showSingInView = await settingViewModel.deleteAccount()
            }
        }
    }
}

#Preview {
    SettingsView(showSingInView: .constant(false))
}
