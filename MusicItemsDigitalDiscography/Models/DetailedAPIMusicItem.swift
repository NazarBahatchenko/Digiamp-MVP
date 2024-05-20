//
//  DetailedAPIMusicItem.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 20.05.2024.
//

import Foundation

struct DetailedAPIMusicItem: Decodable, Equatable {
    var id: Int
    var title: String
    var tracklist: [Track]?
    var videos: [Video]?

    struct Track: Decodable, Equatable, Hashable {
        var position: String?
        var title: String?
        var duration: String?
    }

    struct Video: Decodable, Equatable, Hashable {
        var uri: String
        var title: String
    }
}
