//
//  CoverImageView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 25.05.2024.
//

import SwiftUI
import Kingfisher

struct CoverImageView: View {
    var imageUrl: String
    @State private var imageScale: CGFloat = 1.2
    @State private var rotationAngles: [Double] = Array(repeating: 0.0, count: 4)
    @State private var mainImageRotationAngle: Double = 0.0
    @State private var privateNoteRotationAngle: Double = 0.0

    var body: some View {
        ZStack {
            ForEach(0..<4, id: \.self) { index in
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 250, height: 250)
                    .foregroundStyle(Color("TextColor")).opacity(0.2)
                    .rotationEffect(Angle(degrees: rotationAngles[index]))
                    .offset(x: Double.random(in: -10...10), y: Double.random(in: -10...10))
                    .onAppear {
                        rotationAngles[index] = Double.random(in: -20...20)
                    }
            }
            .shadow(radius: 5)
            
            KFImage(URL(string: imageUrl))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 250, height: 250)
                .cornerRadius(16)
                .clipped()
                .scaleEffect(imageScale)
                .rotationEffect(Angle(degrees: mainImageRotationAngle))
                .onAppear {
                    mainImageRotationAngle = Double.random(in: -15...15)
                    
                    withAnimation(.easeInOut(duration: 0.5)) {
                        imageScale = 1.0
                    }
                }
        }
    }
}

