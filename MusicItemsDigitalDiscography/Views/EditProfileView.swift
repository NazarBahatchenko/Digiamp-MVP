//
//  EditProfileView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 24.04.2024.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var username: String = ""
    @State private var displayName: String = ""
    @State private var bio: String = ""
    @State private var isSaving: Bool = false
    
    private func loadUserData() {
        if let user = userViewModel.currentUser {
            username = user.username
            displayName = user.displayName ?? ""
            bio = user.bio ?? ""
        }
    }

    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("Username", text: $username)
                TextField("Display Name", text: $displayName)
                TextField("Bio", text: $bio)
            }
            Section {
                Button("Save Changes") {
                    Task {
                        await saveChanges()
                    }
                }
                .disabled(isSaving)
            }
        }
        .navigationBarTitle("Edit Profile", displayMode: .inline)
        .onAppear(perform: loadUserData)
    }
    
    private func saveChanges() async {
        guard let currentUser = userViewModel.currentUser else {
            return
        }
        
        let updatedUser = User(
            id: currentUser.id,
            username: username,
            email: currentUser.email,
            displayName: displayName,
            profilePictureURL: currentUser.profilePictureURL,
            bio: bio,
            isDiscogsConnected: currentUser.isDiscogsConnected,
            createdAt: currentUser.createdAt
        )
        
        isSaving = true
        do {
            try await userViewModel.saveUser(updatedUser)
            isSaving = false
            print("User profile updated successfully.")
        } catch {
            isSaving = false
            print("Failed to update user profile: \(error.localizedDescription)")
        }
    }
}

