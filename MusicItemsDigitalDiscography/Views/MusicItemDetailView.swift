//
//  MusicItemDetailView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 03.05.2024.
//
import CoreHaptics
import SwiftUI
import Kingfisher

struct MusicItemDetailView: View {
    var musicItem: MusicItem
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showDetails = false
    @State private var showPrivateNoteView: Bool = false
    @State private var show: String = ""
    @ObservedObject var musicItemViewModel: MusicItemViewModel
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Spacer(minLength: 120)
                    VStack {
                        ZStack {
                            CoverImageView(imageUrl: musicItem.coverImage ?? musicItem.thumb ?? "")
                            if let privateNote = musicItem.privateNote, !privateNote.isEmpty {
                                Button {
                                    impactFeedback(style: .medium)
                                    showPrivateNoteView = true
                                } label: {
                                    PrivateNoteOnTopOfCoverImageView(privateNote: privateNote)
                                }
                                .padding(.horizontal, 30)
                            }
                        }
                        Spacer(minLength: 65)
                        HStack(spacing: 8) {
                            CustomActionButton(
                                action: {
                                    impactFeedback(style: .medium)
                                    print("Log it button is tapped")
                                },
                                buttonText: "Log it",
                                fontSize: 18,
                                cornerRadius: 8,
                                buttonHeight: 40,
                                buttonWidth: 350 - (44 + 44 + 16)
                            )
                            CustomActionButton(
                                action: {
                                    impactFeedback(style: .light)
                                    showPrivateNoteView = true
                                },
                                cornerRadius: 8,
                                buttonHeight: 40,
                                buttonWidth: 44,
                                isButtonWithText: false,
                                imageSystemName: "note.text",
                                imageHeight: 24,
                                imageWidth: 24
                            )
                            CustomActionButton(
                                action: {
                                    impactFeedback(style: .medium)
                                    print("More.... tapped")
                                },
                                cornerRadius: 8,
                                buttonHeight: 40,
                                buttonWidth: 44,
                                isButtonWithText: false,
                                imageSystemName: "ellipsis",
                                imageHeight: 24,
                                imageWidth: 24
                            )
                        }
                        .padding(.horizontal, 20)
                        .frame(width: 350)
                    }
                    .padding(.bottom, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(musicItem.title)
                            .font(.custom("Supreme-Bold", size: 24))
                            .foregroundStyle(Color("TextColor"))
                            .padding(.top, 5)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Divider()
                                .background(Color("AccentColor"))
                                .padding(.vertical, 5)
                            DetailsRowView(name: "YEAR", text: musicItem.year?.isEmpty == false ? musicItem.year! : "No Data", lineLimit: 1)
                            DetailsRowView(name: "COUNTRY", text: musicItem.country?.isEmpty == false ? musicItem.country! : "No Data", lineLimit: 1)
                            DetailsRowView(name: "GENRE", text: musicItem.genre?.isEmpty == false ? musicItem.genre!.joined(separator: ", ") : "No Data", lineLimit: 1)
                            DetailsRowView(name: "STYLE", text: musicItem.style?.isEmpty == false ? musicItem.style!.joined(separator: ", ") : "No Data", lineLimit: 1)
                            Divider()
                                .background(Color("AccentColor"))
                                .padding(.vertical, 5)
                            DetailsRowView(name: "LABEL", text: musicItem.label?.isEmpty == false ? musicItem.label!.joined(separator: ", ") : "No Data", lineLimit: 2)
                            DetailsRowView(name: "CATALOG NUMBER", text: musicItem.catno?.isEmpty == false ? musicItem.catno! : "No Data", lineLimit: 2)
                            DetailsRowView(name: "BARCODE", text: musicItem.barcode?.isEmpty == false ? musicItem.barcode! : "No Data", lineLimit: 2)
                        }
                        
                        Divider()
                            .background(Color("AccentColor"))
                            .padding(.vertical, 5)
                        
                        Button(action: {
                            withAnimation {
                                showDetails.toggle()
                            }
                        }) {
                            ShowDetailsButtonView(showDetails: $showDetails)
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
                                            if let duration = track.duration, !duration.isEmpty {
                                                Text("[\(duration)]")
                                                    .font(.custom("Poppins-Regular", size: 16))
                                                    .foregroundStyle(Color("TextColor"))
                                                    .lineLimit(2)
                                                    .padding(.bottom, 3)
                                            } else {
                                                Text("[00:00]")
                                                    .font(.custom("Poppins-Italic", size: 16))
                                                    .foregroundColor(Color.gray)
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
                                        VStack(alignment: .leading) {
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
                .padding(.bottom, 50)
            }
            .background(Color("MainColor")).ignoresSafeArea(.all)
        }
        .navigationBarTitle(Text("Details"), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
        })
        .sheet(isPresented: $showPrivateNoteView) {
            AddPrivateNoteView(musicItem: musicItem, firestoreViewModel: FirestoreViewModel(), musicItemViewModel: MusicItemViewModel())
                .environmentObject(AuthenticationViewModel())
                .presentationDetents([.large])
        }
    }
}

extension MusicItemDetailView {
    private func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
