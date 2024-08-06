//
//  CollectionListView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 25.04.2024.
//

import SwiftUI
import CoreHaptics

struct CollectionListView: View {
    @ObservedObject var viewModel: MusicItemViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @ObservedObject var discogsViewModel: DiscogsAPIViewModel
    @State private var isPresentingScanner = false
    @State private var isPresentedSettingsSheet = false
    @State private var isPresentedTrashSheet = false
    @State private var isPresentedReviewSheet  = false
    @State private var isPresentingAddMusicItem = false
    @State private var isPresentingSearchDiscogs = false
    @State private var isPresentingAddMusicItemWithFloatingButton = false
    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    Spacer(minLength: 10)
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(viewModel.musicItems, id: \.id) { item in
                            NavigationLink(destination: MusicItemDetailView(musicItem: item, musicItemViewModel: viewModel)) {
                                MusicItemGrid(item: item, viewModel: FirestoreViewModel(), musicItemViewModel: MusicItemViewModel())
                                    .shadow(color: Color.black.opacity(0.3), radius: 2)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .onAppear(perform: viewModel.fetchMusicItemsInCollectionView)
                .navigationTitle("Music Collection")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button(action: {
                                isPresentedSettingsSheet = true
                                impactFeedback(style: .light)
                            }) {
                                Label("Settings", systemImage: "slider.horizontal.3")
                            }
                            Button(action: {
                                isPresentedTrashSheet = true
                                impactFeedback(style: .light)
                            }) {
                                Label("Trash", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.system(size: 18, weight: .medium))
                        }
                        .onTapGesture {
                            impactFeedback(style: .medium)
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Button {
                            print("Top Button in Nav Bar is tapped")
                        } label: {
                            Image("collection_view_logo_50x50")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .cornerRadius(5)
                                .shadow(radius: 2)
                        }
                    }
                }
                .sheet(isPresented: $isPresentedSettingsSheet, content: {
                    SettingsRootView(authViewModel: AuthenticationViewModel())
                })
                .sheet(isPresented: $isPresentedTrashSheet, content: {
                    TrashView(viewModel: viewModel)
                })
                .sheet(isPresented: $isPresentingAddMusicItemWithFloatingButton) {
                                FloatingActionButtonSheetWithSearchOptionsView(
                                    isPresentingAddMusicItem: $isPresentingAddMusicItem,
                                    isPresentingSearchDiscogs: $isPresentingSearchDiscogs,
                                    isPresentingScanner: $isPresentingScanner
                                )
                                .presentationDetents([.height(130)])
                                .transition(.slide)
                                .presentationDragIndicator(.visible)
                            }
                .background(
                    Color("MainColor").ignoresSafeArea()
                )
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            isPresentingAddMusicItemWithFloatingButton = true
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.accentColor)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                        Spacer()
                    }
                }
            }
            .navigationDestination(isPresented: $isPresentingAddMusicItem) {
                AddMusicItemView(addMusicViewModel: FirestoreViewModel())
                    .environmentObject(authViewModel)
            }
            .navigationDestination(isPresented: $isPresentingSearchDiscogs) {
                SearchDiscogsView(viewModel: discogsViewModel)
            }
            .navigationDestination(for: MusicItem.self) { item in
                MusicItemDetailView(musicItem: item, musicItemViewModel: viewModel)
            }
            .navigationDestination(isPresented: $isPresentingScanner) {
                BarCodeScannerView(isPresentingSearchDiscogs: $isPresentingSearchDiscogs, isPresentingScanner: $isPresentingScanner, discogsViewModel: discogsViewModel)
                    .navigationBarBackButtonHidden(true)
                
            }
        }
    }
}

extension CollectionListView {
    private func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

