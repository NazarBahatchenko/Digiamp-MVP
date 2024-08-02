//
//  BarCodeScannerView.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 01.08.2024.
//

import SwiftUI
import CodeScanner

struct BarCodeScannerView: View {
    @Binding var isPresentingSearchDiscogs: Bool
    @Binding var isPresentingScanner: Bool
    @ObservedObject var discogsViewModel: DiscogsAPIViewModel
    @State private var scannedCode: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("MainColor").ignoresSafeArea(.all)
                CodeScannerView(codeTypes: [.ean8, .ean13], simulatedData: "Rick Astley Never Gonna Give You Up") { result in
                    switch result {
                    case .success(let code):
                        scannedCode = code.string
                        discogsViewModel.query = scannedCode ?? ""
                        isPresentingSearchDiscogs = true
                    case .failure(let error):
                        print("Scanning failed: \(error.localizedDescription)")
                    }
                    isPresentingScanner = false
                }
                .frame(height: 600)
                .toolbar {
                    ToolbarItem(placement: .destructiveAction) {
                        Button {
                            isPresentingScanner = false
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color("AccentColor"))
                        }
                    }
                }
                VStack {
                    Text("Scan a barcode on your music piece")
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundStyle(Color("TextColor"))
                        .padding(.top, 20)
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.gray.opacity(0.7), lineWidth: 3)
                    .frame(width: 250, height: 100)
                    .background(Color.clear)
            }
        }
    }
}



