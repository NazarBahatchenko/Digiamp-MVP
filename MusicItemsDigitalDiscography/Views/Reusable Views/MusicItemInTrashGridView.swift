//
//  MusicItemInTrashGridView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 04.05.2024.
//

import SwiftUI
import Kingfisher
import CoreHaptics

struct MusicItemInTrashGridView: View {
    var item: MusicItem
    @State private var showingDeleteAlert = false
    let coverImageSize: CGFloat = 175
    @ObservedObject var viewModel: AddMusicItemViewModel
    @ObservedObject var musicItemViewModel: MusicItemViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            KFImage(URL(string: item.coverImage ?? ""))
                .resizable()
                .placeholder {
                    Image("MusicItemThumbPlaceholder")
                        .resizable()
                        .scaledToFill()
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: coverImageSize, height: coverImageSize)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color("TextColor"), lineWidth: 1)
                        .shadow(color: Color.black.opacity(0.3), radius: 2)
                )
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.custom("Supreme-Bold", size: 16))
                        .lineLimit(2)
                        .foregroundStyle(Color("TextColor"))
                    
                    Text("\(item.style?.first ?? "Unknown Style")")
                        .font(.custom("Poppins-Regular", size: 14))
                        .lineLimit(1)
                        .foregroundStyle(Color("TextColor"))
                    
                }
                .frame(width: 175*0.75, height: 50)
                
                Menu {
                    Button(role: .destructive, action: {
                        showingDeleteAlert = true
                        impactFeedback(style: .light)
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                    Button (action: {
                        Task{
                           await musicItemViewModel.moveMusicItemToCollectionView(itemId: item.id)
                        }
                        impactFeedback(style: .light)
                    }) {
                        Label("Remove from Trash", systemImage: "arrow.uturn.left.square")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .frame(width: 175/3*0.5, height: 175/3*0.5)
                        .background(Color("AccentColorSecondary"))
                        .cornerRadius(8)
                        .foregroundStyle(Color("TextColor"))
                }
                .onTapGesture {
                    impactFeedback(style: .medium)
                }
            }
            .frame(width: coverImageSize, height: 175/3)
        }
        .frame(width: coverImageSize)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete this item? You can't undo this action"),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text("Delete")) {
                    Task {
                      await  viewModel.deleteMusicItem(itemId: item.id, ownerUID: item.ownerUID, coverImageUrl: item.coverImage)
                    }
                }
            )
        }
    }
    private func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
