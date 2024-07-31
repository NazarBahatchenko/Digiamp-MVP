//
//  AddReviewOfMusicItemView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 04.06.2024.
//
import SwiftUI
import PhotosUI
import CoreHaptics
import FirebaseAuth
import FirebaseFirestore

struct AddPrivateNoteView: View {
    var musicItem : MusicItem
    @State private var privateNoteText: String = ""
    @State private var showingAlert = false
    @State private var alertMessage: String = ""
    @ObservedObject var firestoreViewModel: FirestoreViewModel
    @ObservedObject var musicItemViewModel: MusicItemViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var formIncompleteAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color("AccentColorSecondary").ignoresSafeArea(.all)
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("PrivateNoteColor"))
                            .frame(width: 350, height: 50)
                        Text(musicItem.title)
                            .lineLimit(1)
                            .font(.custom("Supreme-Bold", size: 16))
                            .foregroundColor(Color("SystemWhite"))
                    }
                    .padding(.vertical, 10)
                        VStack {
                            TextEditor(text: $privateNoteText)
                                .frame(width: 350)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .font(.custom("Poppins-Regular", size: 24))
                                .foregroundColor(Color("SystemWhite"))
                        }
                        .padding(.horizontal)
                    Spacer()
                }
            }
            .interactiveDismissDisabled()
            .navigationBarTitle("Private Note", displayMode: .inline).foregroundStyle(Color("SystemWhite"))
            .onTapGesture {
                self.hideKeyboardInAddReview()
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        Task {
                            await musicItemViewModel.deletePrivateNoteOfMusicItem(itemId: musicItem.id)
                            impactFeedback(style: .heavy)
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(Color("SystemWhite"))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            await musicItemViewModel.addPrivateNoteToMusicItem(itemId: musicItem.id, reviewText: privateNoteText)
                            dismiss()
                        }
                    } label: {
                        Text("Done")
                            .font(.custom("Supreme-Bold", size: 18))
                            .foregroundStyle(Color("SystemWhite"))
                    }
                }
            }
            .onAppear {
                Task {
                    await loadExistingPrivateNote(itemId: musicItem.id)
                }
            }
        }
    }
}
extension AddPrivateNoteView {
    private func loadExistingPrivateNote(itemId: String) async {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        let itemRef = Firestore.firestore().collection("users")
            .document(userId)
            .collection("userMusicItems")
            .document(itemId)
        do {
            let document = try await itemRef.getDocument()
            if let data = document.data(), let note = data["privateNote"] as? String {
                DispatchQueue.main.async {
                    self.privateNoteText = note
                }
            } else {
                print("No private note found for the given item ID")
            }
        } catch {
            print("Error loading existing private note: \(error.localizedDescription)")
        }
    }
    private func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
   private func hideKeyboardInAddReview() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
