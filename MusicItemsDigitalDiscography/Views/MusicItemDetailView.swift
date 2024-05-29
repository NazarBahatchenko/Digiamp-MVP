//
//  MusicItemDetailView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 03.05.2024.
//

import SwiftUI
import Kingfisher

struct MusicItemDetailView: View {
    var musicItem: MusicItem
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var showDetails = false // State to toggle details visibility
    @State private var musicItemNoteText: String = ""
    
    var body: some View {
        ScrollView {
            Spacer(minLength: 120)
            VStack {
                CoverImageView(imageUrl: musicItem.coverImage ?? musicItem.thumb ?? "")
                Spacer(minLength: 50)
               
                VStack(alignment: .leading, spacing: 8) {
                    Text(musicItem.title)
                        .font(.custom("Supreme-Bold", size: 24))
                        .foregroundStyle(Color("TextColor"))
                        .padding(.top, 5)
                    VStack(alignment: .leading, spacing: 2) {
                        Divider()
                            .background(Color("AccentColor"))
                            .padding(.vertical, 5)
                        DetailsRowView(name: "YEAR", text: musicItem.year ?? "N/A", lineLimit: 1)
                        DetailsRowView(name: "COUNTRY", text: musicItem.country ?? "N/A", lineLimit: 1)
                        DetailsRowView(name: "GENRE", text: musicItem.genre?.joined(separator: ", ") ?? "N/A", lineLimit: 1)
                        DetailsRowView(name: "STYLE", text: musicItem.style?.joined(separator: ", ") ?? "N/A", lineLimit: 1)
                        Divider()
                            .background(Color("AccentColor"))
                            .padding(.vertical, 5)
                        DetailsRowView(name: "LABEL", text: musicItem.label?.joined(separator: ", ") ?? "N/A", lineLimit: 2)
                        DetailsRowView(name: "CATALOG NUMBER", text: musicItem.catno ?? "N/A", lineLimit: 2)
                        DetailsRowView(name: "BARCODE", text: musicItem.barcode ?? "N/A", lineLimit: 2)
                    }
                    
                    Divider()
                        .background(Color("AccentColor"))
                        .padding(.vertical, 5)
                    
                    Button(action: {
                        withAnimation {
                            showDetails.toggle()
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 350, height: 50)
                                .foregroundStyle(Color("MainColor"))
                                .shadow(radius: 1)
                            HStack {
                                Text(showDetails ? "Less Details" : "More Details")
                                    .font(.custom("Poppins-Bold", size: 16))
                                    .foregroundColor(Color("AccentColor"))
                                Spacer()
                                Image(systemName: showDetails ? "chevron.up" : "chevron.down")
                                    .foregroundColor(Color("AccentColor"))
                            }
                            .frame(width: 320, height: 50)
                        }
                    }
                    
                    if showDetails {
                        VStack(alignment: .leading, spacing: 5) {
                            if let tracklist = musicItem.tracklist, !tracklist.isEmpty {
                                Text("TRACKLIST")
                                    .font(.custom("Poppins-Medium", size: 10))
                                    .foregroundStyle(Color("TextColor")).opacity(0.7)
                                ForEach(tracklist, id: \.self) { track in
                                    HStack {
                                        Text("\(track.position ?? "")")
                                            .font(.custom("Poppins-Regular", size: 16))
                                            .foregroundStyle(Color("TextColor"))
                                            .lineLimit(2)
                                            .frame(width: 20)
                                            .padding(.bottom, 3)
                                        
                                        Text("\(track.title ?? "")")
                                            .font(.custom("Poppins-Regular", size: 16))
                                            .foregroundStyle(Color("TextColor"))
                                            .lineLimit(2)
                                            .padding(.bottom, 3)
                                            .padding(.horizontal, 5)
                                        
                                        Spacer()
                                        
                                        if track.duration != nil {
                                            Text("[\(track.duration ?? "N/A")]")
                                                .font(.custom("Poppins-Regular", size: 16))
                                                .foregroundStyle(Color("TextColor"))
                                                .lineLimit(2)
                                                .padding(.bottom, 3)
                                        }
                                    }
                                }
                            } else {
                                Text("NO TRACKLIST AVAILABLE")
                                    .font(.custom("Poppins-Medium", size: 10))
                                    .foregroundStyle(Color("TextColor")).opacity(0.7)
                            }
                            Spacer(minLength: 10)
                            
                            if let videos = musicItem.videos, !videos.isEmpty {
                                Text("VIDEOS")
                                    .font(.custom("Poppins-Medium", size: 10))
                                    .foregroundStyle(Color("TextColor")).opacity(0.7)
                                ForEach(videos, id: \.self) { video in
                                    VStack(alignment: .leading){
                                        Link(destination: URL(string: video.uri)!) {
                                            Text(video.title)
                                                .font(.custom("Poppins-Regular", size: 16))
                                                .foregroundStyle(Color("AccentColorSecondary"))
                                                .lineLimit(2)
                                                .padding(.bottom, 3)
                                        }
                                    }
                                }
                            } else {
                                Text("NO VIDEOS AVAILABLE")
                                    .font(.custom("Poppins-Medium", size: 10))
                                    .foregroundStyle(Color("TextColor")).opacity(0.7)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding(.horizontal, 20)
            }
            Spacer(minLength: 50)
        }
        .frame(minWidth: 390)
        .background(Color("MainColor")).ignoresSafeArea(.all)
        .navigationBarTitle(Text("Details"), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
        })
        .navigationBarTitle("Discogs Catalog", displayMode: .inline)
    }
}

