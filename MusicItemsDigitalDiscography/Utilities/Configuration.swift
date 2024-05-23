//
//  Configuration.swift
//  MusicItemsDigitalDiscography
//
//  Created by Nazar Bahatchenko on 23.05.2024.
//

import Foundation

class Configuration {
    static let shared = Configuration()
    
    var discogsKey: String?
    var discogsSecret: String?
    
    private init() {
        if let path = Bundle.main.path(forResource: "Configuration", ofType: "plist"),
           let config = NSDictionary(contentsOfFile: path) as? [String: Any] {
            discogsKey = config["DISCOGS_KEY"] as? String
            discogsSecret = config["DISCOGS_SECRET"] as? String
        }
    }
}
