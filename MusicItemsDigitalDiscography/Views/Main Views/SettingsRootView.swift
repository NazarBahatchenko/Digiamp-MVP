//
//  AccountView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko
//
import SwiftUI
import FirebaseAuth

struct SettingsRootView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var authViewModel: AuthenticationViewModel
    @State var isNotificationsOn: Bool = false
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Profile")) {
                    if let user = userViewModel.currentUser {
                        ProfileSectionView(user: user)
                    } else {
                        Text("User data is not available.")
                            .foregroundColor(.secondary)
                    }
                }
//                Section(header: Text("Settings")) {
//                    NavigationLink(destination: EditProfileView()) {
//                        Text("Edit Profile")
//                    }
//                    Toggle("Enable Notifications", isOn: $isNotificationsOn)
//                }                
                Section {
                    Button("Log Out") {
                        authViewModel.signOut()
                    }
                    .foregroundColor(.red)
                }
            }
            .onAppear( perform: {
                Task {
                    await userViewModel.fetchCurrentUser()
                }
            })
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await userViewModel.fetchCurrentUser()
                        }
                    }, label: {
                        Image(systemName: "arrow.clockwise.square")
                    })
                }
            }
        }
    }
}


struct ProfileSectionView: View {
    let user: DigiapmUser
    
    var body: some View {
        HStack(spacing: 15) {
            if let photoURL = URL(string: user.profilePictureURL ?? "") {
                AsyncImage(url: photoURL) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
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
