//
//  MusicItem.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 25.04.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MusicItem: Codable, Identifiable, Hashable {
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
    var inTrash: Bool
    var links: [String]?  // New field for links
    var privateNote: String?  // New field for private notes
    var userRating: Int?  // New field for user rating (1-5)
    var tracklist: [Track]?
    var videos: [Video]?

    struct Track: Codable, Equatable, Hashable {
        var position: String?
        var title: String?
        var duration: String?
    }

    struct Video: Codable, Equatable, Hashable {
        var uri: String
        var title: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case addedDate
        case barcode
        case catno
        case country
        case coverImage
        case format
        case genre
        case isPublic
        case label
        case lastEdited
        case ownerUID
        case resourceUrl
        case style
        case thumb
        case title
        case uri
        case year
        case inTrash
        case links
        case privateNote
        case userRating
        case tracklist
        case videos
    }
}
