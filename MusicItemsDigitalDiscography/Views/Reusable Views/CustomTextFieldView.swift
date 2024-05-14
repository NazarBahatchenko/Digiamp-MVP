//
//  CustomTextFieldView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 01.05.2024.
//

import SwiftUI

struct CustomTextFieldView: View {
    @Binding var text: String
    var textFieldTitle: String
    var isNumeric: Bool = false
    var textFieldForegroundText: String = ""
    var textFieldHeight: CGFloat = 40
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(textFieldTitle)
                .font(.custom("Supreme-Medium", size: 14))
                .foregroundColor(Color("TextColor"))

            TextField(textFieldForegroundText, text: $text)
                .padding(.leading)
                .font(.custom("Poppins-Regular", size: 14))
                .frame(height: textFieldHeight)
                .background(Color("MainColor"))
                .foregroundColor(Color("AccentColor"))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("AccentColor"), lineWidth: 0.5)
                )
                .keyboardType(isNumeric ? .numberPad : .default)
                .onReceive(text.publisher.collect()) {
                    if isNumeric {
                        self.text = String($0.filter { "0123456789".contains($0) })
                    }
                }
        }
        .padding(.horizontal)
    }
}
