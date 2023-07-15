//
//  SpotifyUser.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-15.
//

import Foundation

struct SpotifyUser: Decodable {

    let country: String
    let displayName: String
    let email: String
    let explicitContent: ExplicitContent
    let externalUrls: ExternalUrls
    let followers: Followers
    let href: String
    let id: String
    let images: [Image]
    let product: String
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case country
        case displayName = "display_name"
        case email
        case explicitContent = "explicit_content"
        case externalUrls = "external_urls"
        case followers
        case href
        case id
        case images
        case product
        case type
        case uri
    }

    struct ExplicitContent: Decodable {
        let filterEnabled: Bool
        let filterLocked: Bool

        enum CodingKeys: String, CodingKey {
            case filterEnabled = "filter_enabled"
            case filterLocked = "filter_locked"
        }
    }

    struct ExternalUrls: Decodable {
        let spotify: String
    }

    struct Followers: Decodable {
        let href: String
        let total: Int
    }

    struct Image: Decodable {
        let url: String
        let height: Int
        let width: Int
    }
}
