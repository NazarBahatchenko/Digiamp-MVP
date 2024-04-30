//
//  MusicItemViewModel.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 25.04.2024.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class MusicItemViewModel: ObservableObject {
    @Published var musicItems = [MusicItem]()

    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?

    init() {
        fetchMusicItems()
    }

    deinit {
        listenerRegistration?.remove()
    }

    func fetchMusicItems() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }

        listenerRegistration?.remove() // Remove existing listener to prevent duplicates

        let musicItemsRef = db.collection("users").document(userId).collection("userMusicItems")
        listenerRegistration = musicItemsRef.addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No music items found for user")
                return
            }
            
            self.musicItems = documents.compactMap { document -> MusicItem? in
                do {
                    var item = try document.data(as: MusicItem.self)
                    item.id = document.documentID // Manually set the document ID here
                    return item
                } catch {
                    print("Error decoding document \(document.documentID): \(error)")
                    return nil
                }
            }
        }
    }
}

