//
//  MusicItemGrid.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 03.05.2024.
//

import SwiftUI
import Kingfisher
import CoreHaptics

struct MusicItemGrid: View {
    var item: MusicItem
    @State private var showingDeleteAlert = false
    let coverImageSize: CGFloat = 175
    @ObservedObject var viewModel: FirestoreViewModel
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
                .cornerRadius(16)
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
                .frame(width: 135, height: 50)

                Menu {
                    Button(role: .destructive, action: {
                        showingDeleteAlert = true
                        impactFeedback(style: .light)
                    }) {
                        Label("Move to Trash", systemImage: "trash")
                    }

                    Button(action: {
                        print("Edit action triggered")
                        impactFeedback(style: .light)
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .frame(width: 30, height: 30)
                        .background(Color("AccentColor"))
                        .cornerRadius(8)
                        .foregroundStyle(Color("TextColor"))
                }
                .onTapGesture {
                    impactFeedback(style: .medium)
                }
            }
            .frame(width: coverImageSize, height: 60)
        }
        .frame(width: coverImageSize)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Confirm Action"),
                message: Text("Are you sure you want to move this item to trash?"),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text("Move")) {
                    Task {
                        await musicItemViewModel.moveMusicItemToTrash(itemId: item.id)
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
