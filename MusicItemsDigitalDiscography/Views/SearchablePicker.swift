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
             //   .font(.custom("Supreme-Medium", size: 14))
              //  .foregroundColor(Color("TextColor"))
                .font(.system(size: 14))
                .foregroundColor(Color.black)
            
            Button(action: { showPicker = true }) {
                HStack {
                    Text(selection.isEmpty ? "Select" : selection)
                      //  .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(selection.isEmpty ? Color.brown.opacity(0.6) : Color.gray)
                        .padding()
                    Spacer()
                    Image(systemName: "chevron.down")
                        //.foregroundColor(Color("AccentColorSecondary")).opacity(1)
                        .foregroundColor(Color.accentColor).opacity(1)
                        .padding(.trailing)
                }
                .frame(height: 40)
           //     .background(Color("SecondaryColor2"))
                .background(Color.white)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray, lineWidth: 2)
                )
            }
        }
        .padding(.horizontal)
        .sheet(isPresented: $showPicker) {
            NavigationView {
                List {
                    ForEach(options.filter { searchText.isEmpty ? true : $0.localizedCaseInsensitiveContains(searchText) }, id: \.self) { item in
                        Text(item)
                        //    .font(.custom("Poppins-Regular", size: 14))
                            .font(.system(size: 14))
                            .onTapGesture {
                                selection = item
                                showPicker = false
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
}
