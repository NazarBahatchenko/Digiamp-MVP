//
//  AddMusicItemView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 25.04.2024.
//

import SwiftUI
import PhotosUI
import CoreHaptics

struct AddMusicItemView: View {
    @State private var title: String = "_010101"
    @State private var year: String = "2001"
    @State private var country: String = "423"
    @State private var label: String = "423"
    @State private var selectedGenre: String = ""
    @State private var selectedStyle: String = ""
    @State private var barcode: String = "129479431"
    @State private var catno: String = "Rel432"
    @State private var coverImageData: Data? = nil
    
    @State private var showingAlert = false
    @State private var alertMessage: String = ""
    
    @ObservedObject var addMusicViewModel: AddMusicItemViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var formIncompleteAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                Spacer(minLength: 20)
                VStack {
                    HStack {
                        ImagePicker(imageData: $coverImageData)
                            .frame(width: 200, height: 200)
                            .cornerRadius(15)
                            .padding(.all)
                        VStack(alignment: .leading) {
                            Text("*Ideally Cover Image has to have 1:1 aspect ratio")
                                .padding(.bottom)
                            Text("*Ideally Image Size doesn't have to exceed 5 MB")
                            
                        }
                        .padding(.trailing)
                    }
                    VStack(spacing: 15) {
                        CustomTextFieldView(text: $title, textFieldTitle: "Title")
                        CustomTextFieldView(text: $year, textFieldTitle: "Year", isNumeric: true)
                        SearchablePicker(title: "Country", selection: $country, options: addMusicViewModel.countries)
                        CustomTextFieldView(text: $label, textFieldTitle: "Label")
                        SearchablePicker(title: "Genre", selection: $selectedGenre, options: addMusicViewModel.genres)
                        SearchablePicker(title: "Style", selection: $selectedStyle, options: addMusicViewModel.styles)
                        CustomTextFieldView(text: $barcode, textFieldTitle: "Barcode", isNumeric: true)
                        CustomTextFieldView(text: $catno, textFieldTitle: "Catalog Number")
                    }
                    Spacer(minLength: 50)

                    if formIncompleteAlert {
                        Text("Please fill all required fields")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.bottom, 5)
                    }

                    CustomButtonFullScreen(action: {
                        Task {
                            await addMusicItem()
                        }
                    }, buttonText: "Add New Item")
                }
                .padding(.horizontal)
            }
            .background(Color.gray.ignoresSafeArea())
        }
        .navigationBarTitle("Add Music Item", displayMode: .inline)
        .onTapGesture {
            self.hideKeyboard()
        }
    }
    struct ImagePicker: View {
        @Binding var imageData: Data?
        @State private var pickerItem: PhotosPickerItem? = nil
        
        var body: some View {
            PhotosPicker(selection: $pickerItem, matching: .images) {
                VStack {
                    if let imageData = imageData, let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .cornerRadius(15)  // Ensure the image also has rounded corners if desired
                    } else {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.blue.opacity(0.3))
                            .frame(width: 200, height: 200)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15) // Inner rectangle for the stroke
                                    .stroke(Color.green, lineWidth: 3)
                            )
                            .overlay(
                                Text("Select Image")
                                   
                            )
                    }
                    
                }
            }
            .onChange(of: pickerItem) { newItem in
                newItem?.loadTransferable(type: Data.self) { result in
                    switch result {
                    case .success(let data): self.imageData = data
                    case .failure: print("Failed to load image.")
                    }
                }
            }
        }
    }
    
    func triggerHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
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
        await addMusicViewModel.addMusicItemWithImage(ownerUID: ownerUID, title: title, year: year, country: country, label: label, genre: selectedGenre, style: selectedStyle, barcode: barcode, catno: catno, imageData: coverImageData, isPublic: false)
        
        presentationMode.wrappedValue.dismiss()
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
