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
            isLoading = true
            let data = try await networkService.fetchData(from: resourceUrl)
            let decodedResponse = try JSONDecoder().decode(DetailedAPIMusicItem.self, from: data)
            isLoading = false
            return decodedResponse
        } catch {
            print("Error fetching detailed music item: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchSearchResultsWithFormatReleaseOnly(query: String, page: Int) async {
        isLoading = true
        guard let key = Configuration.shared.discogsKey,
              let secret = Configuration.shared.discogsSecret else {
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
        } catch {
            print("Error during API request: \(error.localizedDescription)")
        }
        isLoading = false
    }
    
    func fetchMainAndDetailedData(for APIMusicItem: APIMusicItem) async {
            if let resourceUrl = APIMusicItem.resourceUrl {
                async let detailedItemFetch = fetchDetailedMusicItem(resourceUrl: resourceUrl)
                
                if let detailedItem = await detailedItemFetch {
                    DispatchQueue.main.async {
                        self.detailedMusicItems[APIMusicItem.id] = detailedItem
                    }
                }
            }
        }
}
