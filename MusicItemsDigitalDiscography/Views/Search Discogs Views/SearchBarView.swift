//
//  SearchBarView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 03.05.2024.
//

import SwiftUI
import Combine

struct SearchBarView: View {
    @State private var query = ""
    @StateObject var viewModel: DiscogsAPIViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    // State to manage the debouncing
    @State private var searchCancellable: AnyCancellable?
    
    var body: some View {
        VStack {
            HStack {
                // Improved accessibility by adding labels
                TextField("Search Music", text: $query)
                    .focused($isTextFieldFocused)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color("MainColorLighter"))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                                .accessibility(label: Text("Search Icon"))
                            
                            if !query.isEmpty {
                                Button(action: {
                                    self.query = ""
                                    self.searchCancellable?.cancel()
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(8) // Larger tappable area
                                        .accessibility(label: Text("Clear Search"))
                                }
                                .accessibilityAction {
                                    self.query = ""
                                    self.searchCancellable?.cancel()
                                }
                                .hoverEffect(.lift)
                            }
                        }
                    )
                    .onChange(of: query) { newValue in
                        searchCancellable?.cancel()
                        searchCancellable = Just(newValue)
                            .delay(for: .seconds(0.75), scheduler: RunLoop.main)
                            .sink { _ in
                                Task {
                                    await viewModel.fetchSearchResultsWithFormatReleaseOnly(query: newValue, page: 1)
                                }
                            }
                    }
                    .onAppear {
                        self.isTextFieldFocused = true
                    }
                    .padding(.horizontal, 10)
                
            }
            .padding()
            
        }
    }
}

// Helper extension to hide the keyboard
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

