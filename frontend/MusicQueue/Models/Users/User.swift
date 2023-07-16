//
//  SpotifyUser.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-15.
//

import Foundation

struct User: Decodable {
    
    let country: String
    let displayName: String
    let email: String
    
    init(country: String, displayName: String, email: String) {
        self.country = country
        self.displayName = displayName
        self.email = email
    }
}
