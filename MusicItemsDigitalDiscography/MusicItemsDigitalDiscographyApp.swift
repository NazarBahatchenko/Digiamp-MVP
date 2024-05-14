//
//  MusicItemsDigitalDiscographyApp.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 20.04.2024.
//

import SwiftUI
import FirebaseCore
import Firebase
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct MusicItemsDigitalDiscographyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthenticationViewModel()
    @StateObject var userViewModel = UserViewModel()

    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                NavigationStack {
                    CollectionListView(viewModel: MusicItemViewModel(), discogsViewModel: DiscogsAPIViewModel())
                        .environmentObject(authViewModel)
                        .environmentObject(userViewModel)
                }
            } else {
                LogInView(viewModel: authViewModel)
                    .onOpenURL { url in
                        
                    }
            }
        }
    }
}
