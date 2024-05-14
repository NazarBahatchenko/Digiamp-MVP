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
    @EnvironmentObject var userViewModel : UserViewModel
    @EnvironmentObject var authViewModel : AuthenticationViewModel
    @ObservedObject var discogsViewModel : DiscogsAPIViewModel
    @State private var navigateToAddMusicItem = false
    @State private var navigateToSearchDiscogs = false
    @State private var isPresentingScanner = false
    @State private var isPresentedSettingsSheet = false
    @State private var isPresentedTrashSheet = false
    @State private var scannedCode: String?

    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    Spacer(minLength: 10)
                    LazyVGrid(columns: columns, spacing: 5) {
                        if viewModel.isLoading == true {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(Color("TextColor"))
                                ProgressView()
                                    .scaleEffect(2)
                                    .frame(width: 175, height: 175)
                            }
                        } else {
                            ForEach(viewModel.musicItems, id: \.id) { item in
                                NavigationLink(destination: MusicItemDetailView(musicItem: item)) {
                                    MusicItemGrid(item: item, viewModel: AddMusicItemViewModel(), musicItemViewModel: MusicItemViewModel())
                                        .shadow(color: Color.black.opacity(0.3), radius: 2)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .onAppear(perform: viewModel.fetchMusicItemsInCollectionView)
              .navigationTitle("")
              .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button(action: { isPresentedSettingsSheet = true
                                impactFeedback(style: .light)
                            }) {
                                Label("Settings", systemImage: "slider.horizontal.3")
                            }
                            Button(action: { isPresentedTrashSheet = true
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
                    settingsSheetContent
                })
                .sheet(isPresented: $isPresentedTrashSheet, content: {
                    trashSheetContent
                })
                .sheet(isPresented: $isPresentingScanner) {
                    CodeScannerView(codeTypes: [.ean8, .ean13], simulatedData: "Some simulated data") { result in
                        isPresentingScanner = false
                        switch result {
                        case .success(let code):
                            scannedCode = code.string
                            discogsViewModel.query = scannedCode ?? ""
                            navigateToSearchDiscogs = true
                        case .failure(let error):
                            print("Scanning failed: \(error.localizedDescription)")
                        }
                    }
                }
                .background(
                    Color("MainColor").ignoresSafeArea()
                    
                )
            }
            .background(navigationLinks)
            // Needed for '+' Button to be in the bottom
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    floatingActionButton()
                    Spacer()
                }
            }
        }
    }
    
    
    private func floatingActionButton() -> some View {
        Menu {
            Button(action: {
                impactFeedback(style: .light)
                navigateToAddMusicItem = true
            }) {
                Label("Add Manually", systemImage: "square.and.pencil")
            }
            Button(action: {
                impactFeedback(style: .light)
                navigateToSearchDiscogs = true
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
    
    

    private var settingsSheetContent: some View {
        SettingsRootView(authViewModel: AuthenticationViewModel())
    }
    
    private var trashSheetContent: some View {
        TrashView(viewModel: viewModel)
    }
    
    private var navigationLinks: some View {
        Group {
            NavigationLink(destination: AddMusicItemView(addMusicViewModel: AddMusicItemViewModel())
                .environmentObject(authViewModel), isActive: $navigateToAddMusicItem) {
                    EmptyView()
                    NavigationLink(destination: SearchDiscogsView(viewModel: discogsViewModel), isActive: $navigateToSearchDiscogs) { EmptyView() }
                }
        }
    }
    
    private func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}


