//
//  APIMusicItem.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 03.05.2024.
//

import Foundation

struct APIMusicResponse: Decodable, Equatable {
    let results: [APIMusicItem]
}

struct APIMusicItem: Decodable, Equatable {
    var id: Int
    var type: String?
    var uri: String
    var title: String
    var thumb: String
    var coverImage: String?
    var resourceUrl: String?
    var year: String?
    var country: String?
    var format: [String]?
    var label: [String]?
    var genre: [String]?
    var style: [String]?
    var barcode: [String]?
    var catno: String?
    var formats: [Format]?

    enum CodingKeys: String, CodingKey {
        case id, type, title, thumb, uri, year, country, format, label, genre, style, barcode, catno, formats
        case coverImage = "cover_image", resourceUrl = "resource_url"
    }

    struct Format: Decodable, Equatable {
        var name: String?
        var qty: String?
        var descriptions: [String]?
    }
}




