//
//  CustomButtonFullScreen.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 01.05.2024.
//

import SwiftUI

struct CustomButtonFullScreen: View {
    let action: () async -> Void
    var buttonText: String
    var backgroundColor: Color = Color("AccentColor")
    var textColor: Color = Color("SystemBrightWhite")
    var fontName: String = "Supreme-Bold"
    var fontSize: CGFloat = 16
    var cornerRadius: CGFloat = 15
    var buttonHeight: CGFloat = 50
    var buttonWidth: CGFloat = 350
    
    var body: some View {
        Button(action: {
            Task {
                await action()
            }
        }) {
            Text(buttonText)
                .fontWeight(.medium)
                .font(.custom(fontName, size: fontSize))
                .frame(width: buttonWidth, height: buttonHeight)
                .background(backgroundColor)
                .foregroundColor(textColor)
                .cornerRadius(cornerRadius)
                .shadow(radius: 3)
        }
        .padding()
    }
}
