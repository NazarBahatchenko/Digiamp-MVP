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
    @State var isNotificationsOn: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea(.all)
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if let user = userViewModel.currentUser {
                            VStack(alignment: .leading) {
                                ProfileSectionView(user: user)
                                    .frame(maxWidth: .infinity)
                                    .padding(.all)
                                GroupBox {
                                    settingToggle("Enable Notifications", isOn: $isNotificationsOn)
                                        .padding(.horizontal)
                                }
                                NavigationLink(destination: EditProfileView()) {
                                    Text("Edit Profile")
                                        .foregroundColor(.blue)
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            Text("User data is not available.")
                                .padding()
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Account Settings")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    await userViewModel.fetchCurrentUser()
                }
            }
        }
    }
    
    @ViewBuilder
    private func settingToggle(_ title: String, isOn: Binding<Bool>) -> some View {
        Toggle(title, isOn: isOn)
            .toggleStyle(SwitchToggleStyle(tint: Color.blue))
            .padding()
    }
}

struct ProfileSectionView: View {
    let user: User
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if let photoURL = URL(string: user.profilePictureURL ?? "") {
                AsyncImage(url: photoURL) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.gray)
                }
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.gray)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            }
            VStack(alignment: .leading) {
                Text(user.displayName ?? "Anonymous")
                    .font(.headline)
                Text(user.email ?? "No email")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.leading)
        }
        .padding()
        .background(Color("SecondaryColor2"))
        .cornerRadius(10)
    }
}

#Preview {
    AccountView()
}
