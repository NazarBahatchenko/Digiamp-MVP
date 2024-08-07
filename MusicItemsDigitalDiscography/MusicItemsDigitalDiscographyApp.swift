//
//  MusicItemsDigitalDiscographyApp.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko
//
import SwiftUI
import FirebaseCore
import Firebase
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
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
    @State private var showSplashScreen = true // State variable for splash screen

    var body: some Scene {
        WindowGroup {
            if showSplashScreen {
                SplashScreenView()
                    .onAppear {
                        // Hide the splash screen after 1 second
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation {
                                showSplashScreen = false
                            }
                        }
                    }
            } else {
                if authViewModel.isAuthenticated {
                    NavigationStack {
                        CollectionListView(viewModel: MusicItemViewModel(), discogsViewModel: DiscogsAPIViewModel())
                            .environmentObject(authViewModel)
                            .environmentObject(userViewModel)
                    }
                } else {
                    LogInView(viewModel: authViewModel)
                        .environmentObject(authViewModel)
                        .environmentObject(userViewModel)
                }
            }
        }
    }
}
