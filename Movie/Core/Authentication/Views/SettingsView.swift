//
//  SettingsView.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var settingsViewModel = SettingsViewModel()
    @Binding var showSingInView: Bool
    

    var body: some View {
        List {
            signOutButton
            deleteAccountButton
        }
        .navigationTitle("Settings")
        .alert(settingsViewModel.alertTitle, isPresented: $settingsViewModel.showAlert) {
            Text(settingsViewModel.alertMsg)
        }
    }

    // MARK: - Computed properties

    private var signOutButton: some View {
        Button("Sign out") {
            showSingInView =  settingsViewModel.signOut()
        }
    }

    private var deleteAccountButton: some View {
        Button("Delete account", role: .destructive) {
            Task {
                showSingInView = await settingsViewModel.deleteAccount()
            }
        }
    }
}

#Preview {
    SettingsView(showSingInView: .constant(false))
}
