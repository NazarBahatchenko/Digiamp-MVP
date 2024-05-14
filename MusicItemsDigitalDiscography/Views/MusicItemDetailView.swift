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
    
    @State private var imageScale: CGFloat = 1.2
    @State private var rotationAngles: [Double] = Array(repeating: 0.0, count: 4)
    @State private var mainImageRotationAngle: Double = 0.0
    @State private var musicItemNoteText: String = ""
    
    var body: some View {
        ScrollView {
            Spacer(minLength: 120)
            VStack {
                ZStack {
                    ForEach(0..<4, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 7)
                            .frame(width: 250, height: 250)
                            .foregroundStyle(Color("TextColor")).opacity(0.2)
                            .rotationEffect(Angle(degrees: rotationAngles[index]))
                            .onAppear {
                                rotationAngles[index] = Double.random(in: -20...20)
                            }
                            .offset(x: Double.random(in: -10...10), y: Double.random(in: -10...10))
                    }
                    .shadow(radius: 5)
                    
                    KFImage(URL(string: (((musicItem.coverImage ?? musicItem.thumb) ?? ""))))
                        .resizable()
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
                        }
                }
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
                        DetailsRowView(name: "BARCODE", text: musicItem.barcode ?? "N/a", lineLimit: 2)
                    }
                }
                .padding(.horizontal, 20)
            }
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
