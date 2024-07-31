//
//  ShowDetailsButtonView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 23.07.2024.
//

import SwiftUI

struct ShowDetailsButtonView: View {
    @Binding var showDetails: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 350, height: 50)
                .foregroundStyle(Color("MainColor"))
            HStack {
                Text(showDetails ? "Less Details" : "More Details")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(Color("AccentColor"))
                Spacer()
                Image(systemName: showDetails ? "chevron.up" : "chevron.down")
                    .foregroundColor(Color("AccentColor"))
            }
            .frame(width: 320, height: 50)
        }
    }
}

