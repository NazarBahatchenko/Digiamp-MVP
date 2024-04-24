//
//  LogInView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 20.04.2024.
//

import SwiftUI
import FirebaseAuth

struct LogInView: View {
    @ObservedObject var viewModel = AuthenticationViewModel()

    var body: some View {
        VStack {
            if viewModel.isAuthenticated {
                Button("Sign Out") {
                    viewModel.signOut()
                }
            } else {
                Button("Sign In with Google") {
                    Task {
                        let success = await viewModel.signInWithGoogle()
                        if !success {
                            print("Failed to sign in with Google.")
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            // This line is redundant if `isAuthenticated` is correctly updated by the view model.
            // Uncomment only if necessary to handle edge cases.
            // self.viewModel.isAuthenticated = Auth.auth().currentUser != nil
        }
    }
}

#Preview {
    LogInView()
}
