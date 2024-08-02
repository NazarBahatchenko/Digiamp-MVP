//
//  SearchDiscogsView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 03.05.2024.
//

import SwiftUI
import Kingfisher

struct SearchDiscogsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: DiscogsAPIViewModel
    
    var body: some View {
        ZStack {
            Color("MainColor").ignoresSafeArea(.all)
            NavigationStack {
                ScrollView {
                    LazyVStack {
                        SearchBarView(viewModel: viewModel)
                        
                        if viewModel.isLoading && viewModel.APIMusicItems.isEmpty {
                            ProgressView()
                                .padding()
                        } else {
                            ForEach(viewModel.APIMusicItems, id: \.id) { item in
                                NavigationLink(destination: APIMusicItemDetailView(APIMusicItem: item)) {
                                    APIMusicItemCellView(item: item)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .navigationBarTitle("Discogs Catalog", displayMode: .inline)
        }
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .medium))
        }
    }
}

#Preview {
    SearchDiscogsView(viewModel: DiscogsAPIViewModel())
}
