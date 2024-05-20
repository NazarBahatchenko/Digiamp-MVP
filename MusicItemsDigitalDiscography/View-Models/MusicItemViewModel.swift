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

class MusicItemViewModel: ObservableObject {
    @Published var musicItems = [MusicItem]()
    
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    var isLoading = false
    
    init() {
        fetchMusicItemsInCollectionView()
    }
    
    deinit {
        listenerRegistration?.remove()
    }
    
    func fetchMusicItemsInCollectionView() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        isLoading = true
        
        listenerRegistration?.remove() // Remove existing listener to prevent duplicates
        
        let musicItemsRef = db.collection("users").document(userId).collection("userMusicItems").whereField("inTrash", isEqualTo: false)
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
        isLoading = false
    }
    
    func fetchMusicItemsInTrashView() {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        isLoading = true
        
        listenerRegistration?.remove() // Remove existing listener to prevent duplicates
        
        let musicItemsRef = db.collection("users").document(userId).collection("userMusicItems").whereField("inTrash", isEqualTo: true)
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
        isLoading = false
    }
    
    func moveMusicItemToTrash(itemId: String) async {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        // Reference to the specific document in the Firestore subcollection
        let itemRef = Firestore.firestore().collection("users")
            .document(userId)
            .collection("userMusicItems")
            .document(itemId)
        
        do {
            // Use the 'updateData' method to update the 'inTrash' field to true
            try await itemRef.updateData(["inTrash": true])
            print("Document successfully updated to inTrash")
        } catch {
            print("Error updating document: \(error.localizedDescription)")
        }
    }
    
    func moveMusicItemToCollectionView(itemId: String) async {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        // Reference to the specific document in the Firestore subcollection
        let itemRef = Firestore.firestore().collection("users")
            .document(userId)
            .collection("userMusicItems")
            .document(itemId)
        
        do {
            // Use the 'updateData' method to update the 'inTrash' field to true
            try await itemRef.updateData(["inTrash": false])
            print("Document successfully updated to inTrash")
        } catch {
            print("Error updating document: \(error.localizedDescription)")
        }
    }
    
    // Methods to update links, private notes, and user ratings
    func updateMusicItemLinks(itemId: String, links: [String]) async {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        let itemRef = Firestore.firestore().collection("users")
            .document(userId)
            .collection("userMusicItems")
            .document(itemId)
        
        do {
            try await itemRef.updateData(["links": links])
            print("Links successfully updated")
        } catch {
            print("Error updating links: \(error.localizedDescription)")
        }
    }
    
    func updateMusicItemPrivateNote(itemId: String, privateNote: String) async {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        let itemRef = Firestore.firestore().collection("users")
            .document(userId)
            .collection("userMusicItems")
            .document(itemId)
        
        do {
            try await itemRef.updateData(["privateNote": privateNote])
            print("Private note successfully updated")
        } catch {
            print("Error updating private note: \(error.localizedDescription)")
        }
    }
    
    func updateMusicItemUserRating(itemId: String, userRating: Int) async {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        let itemRef = Firestore.firestore().collection("users")
            .document(userId)
            .collection("userMusicItems")
            .document(itemId)
        
        do {
            try await itemRef.updateData(["userRating": userRating])
            print("User rating successfully updated")
        } catch {
            print("Error updating user rating: \(error.localizedDescription)")
        }
    }
}

