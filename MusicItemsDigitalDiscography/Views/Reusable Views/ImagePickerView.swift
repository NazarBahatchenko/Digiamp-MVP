//
//  ImagePickerView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 23.07.2024.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct ImagePickerView: View {
    @Binding var imageData: Data?
    @State private var pickerItem: PhotosPickerItem?
    var body: some View {
        PhotosPicker(selection: $pickerItem, matching: .images) {
            VStack {
                if let imageData = imageData, let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .cornerRadius(16)  // Ensure the image also has rounded corners if desired
                } else {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color("AccentColor").opacity(0.1))
                        .frame(width: 200, height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15) // Inner rectangle for the stroke
                                .stroke(Color("TextColor"), lineWidth: 2)
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
