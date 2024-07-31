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
    @State private var title: String = ""
    @State private var year: String = ""
    @State private var country: String = ""
    @State private var label: String = ""
    @State private var selectedGenre: String = ""
    @State private var selectedStyle: String = ""
    @State private var barcode: String = ""
    @State private var catno: String = ""
    @State private var coverImageData: Data?
    @State private var showingAlert = false
    @State private var alertMessage: String = ""
    @ObservedObject var addMusicViewModel: FirestoreViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var formIncompleteAlert = false
    var body: some View {
        ZStack {
            Color("MainColor").ignoresSafeArea(.all)
            ScrollView {
                Spacer(minLength: 20)
                VStack {
                    HStack {
                        ImagePickerView(imageData: $coverImageData)
                            .frame(width: 200, height: 200)
                            .cornerRadius(16)
                            .padding(.all)
                        VStack(alignment: .leading) {
                            Text("*Ideally Cover Image has to have 1:1 aspect ratio")
                                .font(.custom("Poppins-Regular", size: 14))
                                .foregroundColor(Color("TextColor"))
                                .padding(.bottom)
                            Text("*Ideally Image Size doesn't have to exceed 5 MB")
                                .font(.custom("Poppins-Regular", size: 14))
                                .foregroundColor(Color("TextColor"))
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
                    CustomActionButton(action: {
                        Task {
                            await addMusicItemWithFormValidation()
                        }},
                        buttonText: "Add New Item")
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitle("Add Music Item", displayMode: .inline)
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}

extension AddMusicItemView {
    private func triggerHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    private func addMusicItemWithFormValidation() async {
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
        await addMusicViewModel.addMusicItemWithImage(ownerUID: ownerUID, title: title, year: year, country: country, label: label,
                                                      genre: selectedGenre, style: selectedStyle, barcode: barcode, catno: catno, imageData: coverImageData, isPublic: false, inTrash: false)
        presentationMode.wrappedValue.dismiss()
    }
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
