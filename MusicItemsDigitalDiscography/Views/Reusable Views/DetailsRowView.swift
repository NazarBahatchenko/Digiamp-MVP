//
//  DetailsRowView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 03.05.2024.
//

import SwiftUI

struct DetailsRowView: View {
    var name: String
    var text: String = "N/A"
    var lineLimit: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(name)
                .font(.custom("Poppins-Medium", size: 10))
                .foregroundStyle(Color("TextColor")).opacity(0.7)
            HStack {
                Text(text)
                    .font(.custom("Poppins-Regular", size: 16))
                    .foregroundStyle(Color("TextColor"))
                    .lineLimit(lineLimit)
                Spacer() // To push content to the left
            }
        }
        .padding(.vertical, 5)
    }
}
