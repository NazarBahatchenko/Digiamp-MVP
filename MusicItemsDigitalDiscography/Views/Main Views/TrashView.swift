//
//  TrashView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko
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
            ZStack {
                Color("MainColor").ignoresSafeArea(.all)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(viewModel.musicItems, id: \.id) { item in
                            NavigationLink(destination: MusicItemDetailView(musicItem: item, musicItemViewModel: MusicItemViewModel())) {
                                MusicItemInTrashGridView(item: item, viewModel: FirestoreViewModel(), musicItemViewModel: MusicItemViewModel())
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
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                })
            }
        }
    }
}

