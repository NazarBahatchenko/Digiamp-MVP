//
//  CollectionListView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 25.04.2024.
//

import SwiftUI
import CodeScanner
import CoreHaptics

struct CollectionListView: View {
    @ObservedObject var viewModel: MusicItemViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @ObservedObject var discogsViewModel: DiscogsAPIViewModel
    @State private var isPresentingScanner = false
    @State private var isPresentedSettingsSheet = false
    @State private var isPresentedTrashSheet = false
    @State private var scannedCode: String?
    @State private var isPresentingAddMusicItem = false // State variable for AddMusicItemView
    @State private var isPresentingSearchDiscogs = false // State variable for SearchDiscogsView

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
                            NavigationLink(value: NavigationDestination.musicItemDetail(item)) {
                                MusicItemGrid(item: item, viewModel: AddMusicItemViewModel(), musicItemViewModel: viewModel)
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
                        }
                        .onTapGesture {
                            impactFeedback(style: .medium)
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Button {
                            print("Top Button in Nav Bar is tapped")
                        } label: {
                            Image("LogInViewImage")
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
                .sheet(isPresented: $isPresentingScanner) {
                    CodeScannerView(codeTypes: [.ean8, .ean13], simulatedData: "Some simulated data") { result in
                        isPresentingScanner = false
                        switch result {
                        case .success(let code):
                            scannedCode = code.string
                            discogsViewModel.query = scannedCode ?? ""
                            isPresentingSearchDiscogs = true
                        case .failure(let error):
                            print("Scanning failed: \(error.localizedDescription)")
                        }
                    }
                }
                .background(
                    Color("MainColor").ignoresSafeArea()
                )
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        floatingActionButton()
                        Spacer()
                    }
                }
            }
            .navigationDestination(isPresented: $isPresentingAddMusicItem) {
                AddMusicItemView(addMusicViewModel: AddMusicItemViewModel())
                    .environmentObject(authViewModel)
            }
            .navigationDestination(isPresented: $isPresentingSearchDiscogs) {
                SearchDiscogsView(viewModel: discogsViewModel)
            }
            .navigationDestination(for: MusicItem.self) { item in
                MusicItemDetailView(musicItem: item)
            }
        }
    }

    private func floatingActionButton() -> some View {
        Menu {
            Button(action: {
                impactFeedback(style: .light)
                isPresentingAddMusicItem = true // Set the state variable
            }) {
                Label("Add Manually", systemImage: "square.and.pencil")
            }
            Button(action: {
                impactFeedback(style: .light)
                isPresentingSearchDiscogs = true // Set the state variable
            }) {
                Label("Add with Discogs", systemImage: "magnifyingglass")
            }
            Button(action: {
                impactFeedback(style: .light)
                isPresentingScanner = true
            }) {
                Label("Add with Barcode", systemImage: "barcode")
            }
        } label: {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 30, height: 30)
                .padding()
                .foregroundColor(.white)
                .background(Color.accentColor)
                .clipShape(Circle())
                .shadow(radius: 3)
        }
        .onTapGesture {
            impactFeedback(style: .medium)
        }
        .padding(.all, 20)
    }

    private func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}



enum NavigationDestination: Hashable {
    case addMusicItem
    case searchDiscogs
    case musicItemDetail(MusicItem)
}

