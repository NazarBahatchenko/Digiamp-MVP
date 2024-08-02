//
//  SearchablePicker.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 01.05.2024.
//

import SwiftUI

struct SearchablePicker: View {
    var title: String
    @Binding var selection: String
    var options: [String]
    @State private var searchText = ""
    @State private var showPicker = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(title)
                .font(.custom("Supreme-Medium", size: 14))
                .foregroundColor(Color("TextColor"))
            
            Button(action: { showPicker = true }) {
                HStack {
                    Text(selection.isEmpty ? "Select \(title)" : selection)
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(selection.isEmpty ? Color("AccentColor").opacity(0.6) : Color("AccentColor"))
                        .padding()
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color("AccentColor"))
                        .padding(.trailing)
                }
                .frame(height: 40)
                .background(Color("MainColor"))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("AccentColor"), lineWidth: 0.5)
                )
            }
        }
        .padding(.horizontal)
        .sheet(isPresented: $showPicker) {
            NavigationView {
                List {
                    ForEach(options.filter { searchText.isEmpty ? true : $0.localizedCaseInsensitiveContains(searchText) }, id: \.self) { item in
                        HStack {
                            Text(item)
                                .font(.custom("Poppins-Regular", size: 14))
                            Spacer()
                        }
                        .contentShape(Rectangle()) // Expand the tap area to the whole width
                        .onTapGesture {
                            selection = item
                            showPicker = false
                        }
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationBarTitle("Select \(title)", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                showPicker = false
            })
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
    }
}
