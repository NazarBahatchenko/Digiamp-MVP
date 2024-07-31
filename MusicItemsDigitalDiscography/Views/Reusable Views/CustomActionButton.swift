//
//  CustomButtonFullScreen.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 01.05.2024.
//

import SwiftUI

struct CustomActionButton: View {
    let action: () async -> Void
    var buttonText: String = ""
    var backgroundColor: Color = Color("AccentColor")
    var textColor: Color = Color("SystemBrightWhite")
    var fontName: String = "Supreme-Extrabold"
    var fontSize: CGFloat = 16
    var cornerRadius: CGFloat = 15
    var buttonHeight: CGFloat = 50
    var buttonWidth: CGFloat = 350
    var shadowRadius: CGFloat = 0
    var isButtonWithText: Bool = true
    var imageSystemName: String = ""
    var imageHeight: CGFloat = 30
    var imageWidth: CGFloat = 30

    var body: some View {
        Button(action: {
            Task {
                await action()
            }
        }) {
            if isButtonWithText {
                Text(buttonText)
                    .font(.custom(fontName, size: fontSize))
                    .foregroundColor(textColor)
                    .frame(width: buttonWidth, height: buttonHeight)
                    .background(backgroundColor)
                    .cornerRadius(cornerRadius)
                    .shadow(radius: shadowRadius)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(backgroundColor)
                        .frame(width: buttonWidth, height: buttonHeight)
                        .shadow(radius: shadowRadius)
                    Image(systemName: imageSystemName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageWidth, height: imageHeight)
                        .foregroundColor(textColor)
                }
            }
        }
    }
}
