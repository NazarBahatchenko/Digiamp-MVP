//
//  DiscogsViewModel.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 03.05.2024.
//

import Foundation

@MainActor
class DiscogsAPIViewModel: ObservableObject {
    private var networkService = NetworkService()
    @Published var APIMusicItems: [APIMusicItem] = []
    @Published var detailedMusicItems: [Int: DetailedAPIMusicItem] = [:]
    @Published var isLoading = false
    @Published var currentPage = 1
    @Published var totalPages = 1
    @Published var query: String = "" {
        didSet {
            Task {
                await fetchSearchResultsWithFormatReleaseOnly(query: query, page: 1)
            }
        }
    }

    func setQueryAndSearch(newQuery: String) {
        query = newQuery
    }
    
    func fetchDetailedMusicItem(resourceUrl: String) async -> DetailedAPIMusicItem? {
        do {
            let data = try await networkService.fetchData(from: resourceUrl)
            
            // Print the raw JSON response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response: \(jsonString)")
            }

            let decodedResponse = try JSONDecoder().decode(DetailedAPIMusicItem.self, from: data)
            print("Decoded detailed item: \(decodedResponse)")
            return decodedResponse
        } catch {
            print("Error fetching detailed music item: \(error.localizedDescription)")
            return nil
        }
    }

    func fetchSearchResultsWithFormatReleaseOnly(query: String, page: Int) async {
        isLoading = true
        guard let key = ProcessInfo.processInfo.environment["DISCOGS_KEY"],
              let secret = ProcessInfo.processInfo.environment["DISCOGS_SECRET"] else {
            print("API credentials are not set.")
            isLoading = false
            return
        }

        let baseURL = "https://api.discogs.com/database/search"
        let searchURL = "\(baseURL)?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&key=\(key)&secret=\(secret)&type=release&page=\(page)&per_page=100"
        
        do {
            let data = try await networkService.fetchData(from: searchURL)
            let decodedResponse = try JSONDecoder().decode(APIMusicResponse.self, from: data)
            DispatchQueue.main.async {
                self.APIMusicItems = decodedResponse.results.filter { $0.type == "release" }
            }

//            // Fetch detailed data for each item
//            for item in self.APIMusicItems {
//                if let resourceUrl = item.resourceUrl {
//                    if let detailedItem = await fetchDetailedMusicItem(resourceUrl: resourceUrl) {
//                        DispatchQueue.main.async {
//                            self.detailedMusicItems[item.id] = detailedItem
//                            print("Updated item with detailed data: \(detailedItem)")
//                        }
//                    }
//                }
//            }
        } catch {
            print("Error during API request: \(error.localizedDescription)")
        }
        isLoading = false
    }
}
