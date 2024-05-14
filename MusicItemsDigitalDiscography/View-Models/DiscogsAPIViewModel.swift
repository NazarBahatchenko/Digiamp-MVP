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

    // Call this method to update the query and trigger a search
    func setQueryAndSearch(newQuery: String) {
        query = newQuery
    }
    
    // MARK: - Discogs Search
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
                self.currentPage = decodedResponse.pagination.page
                self.totalPages = (decodedResponse.pagination.items + 49) / 50 // Calculate total pages needed
            }
        } catch {
            print("Error during API request: \(error.localizedDescription)")
        }
        isLoading = false
    }

    func loadNextPage() {
        guard currentPage < totalPages else { return }
        Task {
            await fetchSearchResultsWithFormatReleaseOnly(query: query, page: currentPage + 1)
        }
    }
}
    
