//
//  TrashView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 03.05.2024.
//

import SwiftUI

struct TrashView: View {
    @ObservedObject var viewModel: MusicItemViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(viewModel.musicItems, id: \.id) { item in
                        NavigationLink(destination: MusicItemDetailView(musicItem: item)) {
                            MusicItemInTrashGridView(item: item, viewModel: AddMusicItemViewModel(), musicItemViewModel: MusicItemViewModel())
                                .shadow(color: Color.black.opacity(0.3), radius: 2)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                     viewModel.fetchMusicItemsInTrashView()
            }
            .onDisappear{
                viewModel.fetchMusicItemsInCollectionView()
            }
            .navigationTitle("Trash")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark") // Custom close button
            })
        }
    }
}

