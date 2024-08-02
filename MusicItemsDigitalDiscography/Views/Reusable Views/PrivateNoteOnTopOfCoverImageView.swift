//
//  PrivateNoteOnTopOfCoverImageView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 30.07.2024.
//

import SwiftUI

struct PrivateNoteOnTopOfCoverImageView: View {
    @State private var privateNoteRotationAngle: Double = 0.0
    @State private var privateNoteScale: CGFloat = 1.2
    var privateNote: String
    
    var body: some View {
        HStack {
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("PrivateNoteColor"))
                    .frame(width: 140, height: 150)
                Text(privateNote)
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundStyle(Color("SystemWhite"))
                    .frame(width: 130, height: 140)
                
            }
            .scaleEffect(privateNoteScale)
            .rotationEffect(Angle(degrees: privateNoteRotationAngle))
            .onAppear {
                privateNoteRotationAngle = Double.random(in: -20...10)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        privateNoteScale = 1.0
                    }
                }
            }
        }
    }
}
