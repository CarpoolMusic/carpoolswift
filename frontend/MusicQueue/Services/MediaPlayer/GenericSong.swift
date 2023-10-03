//
//  GenericSong.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-17.
//

protocol GenericSong {
    var id: Int { get }
    var title: String { get }
    var artist: String { get }
    var album: String { get }
    var duration: TimeInterval { get }
    var uri: URL { get }
    var artworkURL: URL { get }
    var votes: Int { get }
    func toJSONData() -> Data?
}

// Inner struct to convert only the properties we need
struct EncodableGenericSong: Codable {
    var id: Int
    var votes: Int
    var title: String
    var artist: String
    var album: String
    var duration: TimeInterval
    var uri: URL
}
