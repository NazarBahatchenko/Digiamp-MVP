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
            
            VStack {
                HStack {
                    if textFieldHeight > 40 {
                        TextEditor(text: $text)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .background(Color("MainColor"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("AccentColor"), lineWidth: 0.5)
                            )
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(Color("AccentColor"))
                            .frame(height: textFieldHeight)
                    } else {
                        TextField(textFieldForegroundText, text: $text)
                            .padding(8) // Padding inside the TextField for user input
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("MainColor"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color("AccentColor"), lineWidth: 0.5)
                                    )
                            )
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(Color("AccentColor"))
                            .frame(height: textFieldHeight)
                            .keyboardType(isNumeric ? .numberPad : .default)
                            .onReceive(text.publisher.collect()) {
                                if isNumeric {
                                    self.text = String($0.filter { "0123456789".contains($0) })
                                }
                            }
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
