//
//  AccountView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 24.04.2024.
//

import SwiftUI
import FirebaseAuth

struct AccountView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var authViewModel: AuthenticationViewModel
    @State var isNotificationsOn: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                if let user = userViewModel.currentUser {
                    Section(header: Text("Profile")) {
                        ProfileSectionView(user: user)
                    }
                    Section(header: Text("Settings")) {
                        Toggle("Enable Notifications", isOn: $isNotificationsOn)
                        NavigationLink(destination: EditProfileView()) {
                            Text("Edit Profile")
                        }
                    }
                } else {
                    Text("User data is not available.")
                        .foregroundColor(.secondary)
                }
                Button("Log Out", action: authViewModel.signOut)
            }
            .onAppear(perform: {
                Task {
                    await userViewModel.fetchCurrentUser()
                }
            })
            .listStyle(GroupedListStyle())
            .navigationTitle("Account Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Refresh") {
                        Task {
                            await userViewModel.fetchCurrentUser()
                        }
                    }
                }
            }
        }
    }
}

struct ProfileSectionView: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 15) {
            if let photoURL = URL(string: user.profilePictureURL ?? "") {
                AsyncImage(url: photoURL) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else if phase.error != nil {
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                    }
                }
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(user.displayName ?? "Anonymous")
                    .font(.headline)
                Text(user.email ?? "No email available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    AccountView(authViewModel: AuthenticationViewModel())
}
