//
//  UserViewModel.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 24.04.2024.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserViewModel: ObservableObject {
    @Published var currentUser: DigiapmUser?
    private var db = Firestore.firestore()

    func fetchCurrentUser() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user ID available")
            return
        }
        let docRef = db.collection("users").document(userId)

        do {
            let document = try await docRef.getDocument()
            // Use try? for conditional check and unwrap in a single if let
            if let user = try? document.data(as: DigiapmUser.self) {
                DispatchQueue.main.async {
                    self.currentUser = user
                }
            } else {
                print("Document does not exist or cannot be decoded")
            }
        } catch {
            print("Error fetching user: \(error)")
        }
    }

    func saveUser(_ user: DigiapmUser) async throws {
        let docRef = db.collection("users").document(user.id)
        do {
            try docRef.setData(from: user)
            DispatchQueue.main.async {
                self.currentUser = user
            }
        } catch {
            throw error
        }
    }
}


