//
//  CollectionListView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 25.04.2024.
//

import SwiftUI
import Kingfisher

struct CollectionListView: View {
    @ObservedObject var viewModel: MusicItemViewModel
    @State private var navigateToAddItem = false

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: AddMusicItemView(addMusicViewModel: AddMusicItemViewModel()), isActive: $navigateToAddItem) {
                    EmptyView()
                }

                List(viewModel.musicItems) { musicItem in
                        MusicItemRow(musicItem: musicItem)
                }

                Button("Add Item") {
                    navigateToAddItem = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
            }
            .navigationTitle("Music Collection")
        }
    }
}

struct MusicItemRow: View {
    let musicItem: MusicItem

    var body: some View {
        HStack {
            KFImage(URL(string: musicItem.coverImage ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(musicItem.title)
                    .font(.headline)
                    .lineLimit(1)
                
                if let year = musicItem.year, !year.isEmpty {
                    Text("Year: \(year)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let country = musicItem.country, !country.isEmpty {
                    Text("Country: \(country)")
                        .font(.subheadline)
                }
                
                if let genre = musicItem.genre?.joined(separator: ", "), !genre.isEmpty {
                    Text("Genre: \(genre)")
                        .font(.subheadline)
                }
                
                if let style = musicItem.style?.joined(separator: ", "), !style.isEmpty {
                    Text("Style: \(style)")
                        .font(.subheadline)
                }
                
                if let label = musicItem.label?.joined(separator: ", "), !label.isEmpty {
                    Text("Label: \(label)")
                        .font(.subheadline)
                }
            }
            .padding(.vertical, 4)
        }
    }
}


#Preview {
    CollectionListView(viewModel: MusicItemViewModel())
}
