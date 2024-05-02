//
//  MusicItem.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 25.04.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MusicItem: Codable, Identifiable {
    var id: String
    @ServerTimestamp var addedDate: Date?
    var barcode: String?
    var catno: String?
    var country: String?
    var coverImage: String?
    var format: [String]?
    var genre: [String]?
    var isPublic: Bool?
    var label: [String]?
    @ServerTimestamp var lastEdited: Date?
    var ownerUID: String
    var resourceUrl: String?
    var style: [String]?
    var thumb: String?
    var title: String
    var uri: String?
    var year: String?

    enum CodingKeys: String, CodingKey {
        case id, addedDate, barcode, catno, country, coverImage, format, genre, isPublic, label, lastEdited, ownerUID, resourceUrl, style, thumb, title, uri, year
    }
}


