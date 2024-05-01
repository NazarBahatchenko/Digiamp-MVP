//
//  CustomButtonFullScreen.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 01.05.2024.
//

import SwiftUI

struct CustomButtonFullScreen: View {
    let action: () -> Void
    var buttonText: String
    var backgroundColor: Color = Color.brown
    var textColor: Color = Color.blue
    var fontName: String = "Supreme-Bold"
    var fontSize: CGFloat = 16
    var cornerRadius: CGFloat = 15
    var buttonHeight: CGFloat = 80
    var buttonWidth: CGFloat = 350
    
    var body: some View {
        Button(action: action) {
            Text(buttonText)
                .fontWeight(.medium)
                .font(.system(size: 16))
        //        .font(.custom(fontName, size: fontSize))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(backgroundColor)
                .foregroundColor(textColor)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .shadow(color: Color.green.opacity(0.3), radius: 5, x: 5, y: 0)
                .padding()
        }
        .frame(width: buttonWidth, height: buttonHeight)
    }
}

#Preview {
    CustomButtonFullScreen(action: {print("Hello!")}, buttonText: "Add Music Item")
}
