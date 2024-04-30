//
//  TabView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 24.04.2024.
//

import SwiftUI

struct TabBarView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        TabView {
            CollectionListView(viewModel: MusicItemViewModel())
                .environmentObject(AuthenticationViewModel())
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            AccountView(authViewModel: AuthenticationViewModel())
                .environmentObject(userViewModel)
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }
        }
    }
}
