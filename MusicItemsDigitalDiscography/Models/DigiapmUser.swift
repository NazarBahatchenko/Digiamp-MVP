//
//  User.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 24.04.2024.
//

import Foundation

struct DigiapmUser: Codable, Identifiable {
    var id: String  // UID from FirebaseAuth
    var username: String  // Unique username for display and mentions
    var email: String?
    var displayName: String?
    var profilePictureURL: String?
    var bio: String?
    var isDiscogsConnected: Bool = false
    var createdAt: Date?  // Date the user profile was created
}
