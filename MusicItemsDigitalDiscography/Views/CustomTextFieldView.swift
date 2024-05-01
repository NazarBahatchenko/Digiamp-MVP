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
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(textFieldTitle)
         //       .font(.custom("Supreme-Medium", size: 14))
             //   .foregroundColor(Color("TextColor"))
                .font(.system(size: 14))
                .foregroundColor(Color.black)

            TextField(textFieldForegroundText, text: $text)
                .padding(.leading)
           //     .font(.custom("Poppins-Regular", size: 14))
                .font(.system(size: 14))
                .frame(height: 40) // Removed width: .infinity
               .background(Color.white)
               .foregroundColor(Color.blue)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.blue, lineWidth: 2)
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
