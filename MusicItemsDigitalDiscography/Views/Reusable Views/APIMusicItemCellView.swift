//
//  APIMusicItemCellView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 12.05.2024.
//

import SwiftUI
import Kingfisher

struct APIMusicItemCellView: View {
    var item: APIMusicItem

    var body: some View {
        HStack(spacing: 15) {
            if let url = URL(string: item.thumb), UIApplication.shared.canOpenURL(url) {
                KFImage(url)
                    .resizable()
                    .placeholder {
                        Image("MusicItemThumbPlaceholder")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                    }
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
            } else {
                Image("MusicItemThumbPlaceholder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(item.title)
                    .font(.custom("Supreme-Bold", size: 18))
                    .lineLimit(1)
                Text(item.format?.joined(separator: ", ") ?? "N/A")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                Text(item.catno ?? "N/A")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                Text(item.year ?? "N/A")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(2)
    }
}
