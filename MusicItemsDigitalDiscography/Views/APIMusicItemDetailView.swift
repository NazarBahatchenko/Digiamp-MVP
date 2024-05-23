//
//  MusicItemDetailView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 03.05.2024.
//
import SwiftUI
import Kingfisher

struct APIMusicItemDetailView: View {
    var APIMusicItem: APIMusicItem
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var addMusicItemViewModel = FirestoreViewModel()
    @StateObject private var discogsAPIViewModel = DiscogsAPIViewModel()
    @State private var imageScale: CGFloat = 1.2
    @State private var rotationAngles: [Double] = Array(repeating: 0.0, count: 4)
    @State private var mainImageRotationAngle: Double = 0.0
    @State private var showDetails = false // State to toggle details visibility

    var body: some View {
        NavigationStack {
            ScrollView {
                Spacer(minLength: 120)
                VStack {
                    ZStack {
                        ForEach(0..<3, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 250, height: 250)
                                .foregroundStyle(Color("TextColor")).opacity(0.3)
                                .rotationEffect(Angle(degrees: rotationAngles[index]))
                                .onAppear {
                                    rotationAngles[index] = Double.random(in: -20...20)
                                }
                                .offset(x: Double.random(in: -10...10), y: Double.random(in: -10...10))
                        }
                        KFImage(URL(string: (APIMusicItem.coverImage ?? APIMusicItem.thumb)))
                            .resizable()
                            .placeholder {
                                Image("MusicItemThumbPlaceholder")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 250, height: 250)
                                    .cornerRadius(15)
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 250, height: 250)
                            .cornerRadius(15)
                            .clipped()
                            .scaleEffect(imageScale)
                            .rotationEffect(Angle(degrees: mainImageRotationAngle))
                            .onAppear {
                                mainImageRotationAngle = Double.random(in: -15...15)
                                
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    imageScale = 1.0
                                }
                                
                                // Fetch both main data and details concurrently
                                Task {
                                    await discogsAPIViewModel.fetchMainAndDetailedData(for: APIMusicItem)
                                }
                            }
                    }
                    Spacer(minLength: 50)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(APIMusicItem.title)
                            .lineLimit(3)
                            .font(.custom("Supreme-Bold", size: 24))
                            .foregroundStyle(Color("TextColor"))
                            .padding(.top, 5)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Divider()
                                .background(Color("AccentColor"))
                                .padding(.vertical, 5)
                            DetailsRowView(name: "YEAR", text: APIMusicItem.year ?? "N/A", lineLimit: 1)
                            DetailsRowView(name: "COUNTRY", text: APIMusicItem.country ?? "N/A", lineLimit: 1)
                            DetailsRowView(name: "GENRE", text: APIMusicItem.genre?.joined(separator: ", ") ?? "N/A", lineLimit: 1)
                            DetailsRowView(name: "STYLE", text: APIMusicItem.style?.joined(separator: ", ") ?? "N/A", lineLimit: 1)
                            Divider()
                                .background(Color("AccentColor"))
                                .padding(.vertical, 5)
                            DetailsRowView(name: "LABEL", text: APIMusicItem.label?.joined(separator: ", ") ?? "N/A", lineLimit: 2)
                            DetailsRowView(name: "CATALOG NUMBER", text: APIMusicItem.catno ?? "N/A", lineLimit: 2)
                            DetailsRowView(name: "BARCODE", text: APIMusicItem.barcode?.joined(separator: ", ") ?? "N/A", lineLimit: 2)
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
                        
                        // Display tracklist and videos if showDetails is true
                        if showDetails {
                            VStack(alignment: .leading, spacing: 5) {
                                if let detailedItem = discogsAPIViewModel.detailedMusicItems[APIMusicItem.id] {
                                    if let tracklist = detailedItem.tracklist, !tracklist.isEmpty {
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
                                    
                                    if let videos = detailedItem.videos, !videos.isEmpty {
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
                                } else {
                                    ProgressView()
                                        .frame(width: 350, height: 50)
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
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
        })
    }
    
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Menu {
                Button(action: {
                    impactFeedback(style: .light)
                    Task {
                        guard let ownerUID = AuthenticationViewModel().currentUserUID else { return }
                        await addMusicItemViewModel.convertAndSaveToFirestore(apiMusicItem: APIMusicItem, ownerUID: ownerUID)
                        print("MusicItem from Discogs API is saved to Firestore")
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Label("Save to Collection", systemImage: "square.and.arrow.down.on.square")
                }
            } label: {
                Image(systemName: "arrow.down.square")
            }
            .onTapGesture {
                impactFeedback(style: .medium)
            }
        }
    }
    
    private func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
