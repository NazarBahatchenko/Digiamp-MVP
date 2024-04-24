//
//  ContentView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 20.04.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = AuthenticationViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Spacer(minLength: 30)
            Button("Sign Out",action: viewModel.signOut)
                .foregroundStyle(Color(.red))
                .frame(width: 200, height: 65)
                .background(Color.gray)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
