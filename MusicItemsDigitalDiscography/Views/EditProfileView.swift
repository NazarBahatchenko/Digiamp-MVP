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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                CustomTextFieldView(text: $username, textFieldTitle: "Username", isNumeric: false)
                CustomTextFieldView(text: $displayName, textFieldTitle: "Display Name", isNumeric: false)
                CustomTextFieldView(text: $bio, textFieldTitle: "Bio", isNumeric: false)
                
                CustomActionButton(
                           action: saveChanges,
                           buttonText: "Save Changes")
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: loadUserData)
        }
    }

    private func loadUserData() {
        if let user = userViewModel.currentUser {
            username = user.username
            displayName = user.displayName ?? ""
            bio = user.bio ?? ""
        }
    }

    private func saveChanges() async {
        guard let currentUser = userViewModel.currentUser else {
            return
        }
        
        let updatedUser = DigiapmUser(
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
