//
//  SplashScreenView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 14.05.2024.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color("SystemWhite").ignoresSafeArea(.all)
            
            VStack() {
                Spacer()
                Image("LogInViewImage")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .cornerRadius(8)
                Spacer()
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
