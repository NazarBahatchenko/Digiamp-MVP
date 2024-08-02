//
//  CustomFloatingActionButtonView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 31.07.2024.
//

import SwiftUI
import CoreHaptics

struct CustomFloatingActionButtonView: View {
    @Binding var isPresentingAddMusicItem: Bool
    @Binding var isPresentingSearchDiscogs: Bool
    @Binding var isPresentingScanner: Bool
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            ZStack {
                Color("MainColor").ignoresSafeArea(.all)
                HStack {
                    Button(action: {
                        impactFeedback(style: .light)
                        dismiss()
                        isPresentingAddMusicItem = true
                    }) {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color("AccentColor")).opacity(0.5)
                                    .background(.clear)
                                    .frame(width: 50, height: 50)
                                Image(systemName:"square.and.pencil")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color("TextColor"))
                            }
                            .padding(.vertical, 5)
                            Text("Add Manually")
                                .font(.custom("Supreme-Medium", size: 12))
                                .foregroundColor(Color("TextColor"))
                                .frame(width: 50)
                        }
                        .frame(width: 100,height: 100)
                    }
                    
                    Button(action: {
                        impactFeedback(style: .light)
                        dismiss()
                        isPresentingSearchDiscogs = true
                    }) {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color("AccentColor")).opacity(0.5)
                                    .background(.clear)
                                    .frame(width: 50, height: 50)
                                Image(systemName:"magnifyingglass")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("TextColor"))
                            }
                            .padding(.vertical, 5)
                            Text("Add with Discogs")
                                .font(.custom("Supreme-Medium", size: 12))
                                .foregroundColor(Color("TextColor"))
                                .frame(width: 50)
                        }
                        .frame(width: 100,height: 100)
                    }
                    
                    Button(action: {
                        impactFeedback(style: .light)
                        dismiss()
                        isPresentingScanner = true
                    }) {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color("AccentColor")).opacity(0.5)
                                    .background(.clear)
                                    .frame(width: 50, height: 50)
                                Image(systemName:"barcode")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color("TextColor"))
                            }
                            .padding(.vertical, 5)
                            Text("Add with Barcode")
                                .font(.custom("Supreme-Medium", size: 12))
                                .foregroundColor(Color("TextColor"))
                                .frame(width: 50)
                        }
                        .frame(width: 100,height: 100)
                    }
                }
            }
        }
    }
}

extension CustomFloatingActionButtonView {
    private func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
