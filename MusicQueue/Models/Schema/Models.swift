////
////  Models.swift
////  MusicQueue
////
////  Created by Nolan Biscaro on 2024-04-01.
////
//
//struct SocketSong: Codable,  {
//    
//    let id: String
//    let uri: String
//    let title: String
//    let artist: String
//    let album: String
//    let artworkUrl: String
//    var votes: Int
//    let artworkURL: URL?
//    var artworkImage: UIImage?
//    
//    let serviceType: MusicServiceType
//    
//    mutating func upvote() {
//        votes += 1
//    }
//    
//    mutating func downvote() {
//        votes -= 1
//    }
//    
//    func artworkImageURL(size: CGSize) -> URL? {
//        artworkURL
//    }
//    
//    enum CodingKeys: String, CodingKey {
//        case id, uri, title, artist, album, artworkUrl, votes, artworkURL, serviceType
//    }
//}
//
//
//
