//
//  AuthenticationViewModel.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 20.04.2024.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    private var userViewModel = UserViewModel()
    
    init() {
        addAuthStateDidChangeListener()
    }
    
    private func addAuthStateDidChangeListener() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard let self = self else { return }
            self.isAuthenticated = user != nil
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    /// MARK: Google Sign In
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller!")
            return false
        }
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            let user = userAuthentication.user
            guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "Invalid token") }
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
            
            // Save or update the user in Firestore
            let newUser = User(id: firebaseUser.uid,
                               username: firebaseUser.displayName?.replacingOccurrences(of: " ", with: "").lowercased() ?? "user\(Int.random(in: 1000...9999))",
                               email: firebaseUser.email,
                               displayName: firebaseUser.displayName,
                               profilePictureURL: firebaseUser.photoURL?.absoluteString,
                               bio: "",
                               isDiscogsConnected: false,
                               createdAt: Date())
            try await userViewModel.saveUser(newUser)
            
            isAuthenticated = true
            return true
        }
        catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    deinit {
        if let handle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    enum AuthenticationError: Error {
        case tokenError(message: String)
        case authError(message: String)
    }
}

