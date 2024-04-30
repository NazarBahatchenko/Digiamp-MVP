//
//  AddMusicItemView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 25.04.2024.
//

import Foundation
import SwiftUI

struct AddMusicItemView: View {
    @State private var title: String = "_234"
    @State private var year: String = "423"
    @State private var country: String = "423"
    @State private var label: String = "423"
    @State private var selectedGenre: String = "342"
    @State private var selectedStyle: String = "342"
    @State private var barcode: String = "432"
    @State private var catno: String = "432"
    
    @State private var showingAlert = false
    @State private var alertMessage: String = ""
    
    @ObservedObject var addMusicViewModel: AddMusicItemViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    
    var randomString : String = "A"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Title", text: $title)
                    TextField("Year", text: $year)
                    TextField("Country", text: $country)
                    TextField("Label", text: $label)
                    TextField("Genre", text: $selectedGenre)
                    TextField("Style", text: $selectedStyle)
                    TextField("Barcode", text: $barcode)
                    TextField("Catalog Number", text: $catno)
                }
                
                Section {
                    Button("Add New Item") {
                        Task {
                            await addMusicItem()
                        }
                    }
                }
            }
            .navigationBarTitle("Add Music Item", displayMode: .inline)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Submission Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func addMusicItem() async {
        guard let ownerUID = authenticationViewModel.currentUserUID else {
            alertMessage = "Error: User not logged in"
            showingAlert = true
            return
        }
        
        if title.isEmpty || year.isEmpty || country.isEmpty {
            alertMessage = "Please fill all required fields"
            showingAlert = true
            return
        }
        
        // Directly pass non-optional values assuming you handle empty as non-entry in Firestore or your business logic
        await addMusicViewModel.addMusicItemWithoutImage(ownerUID: ownerUID, title: title, year: year, country: country, label: label, genre: selectedGenre, style: selectedStyle, barcode: barcode, catno: catno, isPublic: false)
        
        presentationMode.wrappedValue.dismiss()
    }
}

// Implementation details for `addMusicItemWithoutImage` should ensure handling empty strings appropriately, for example by not setting them in Firestore if they are empty.
