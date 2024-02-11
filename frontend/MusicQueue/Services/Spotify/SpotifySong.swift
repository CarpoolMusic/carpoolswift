//
//  SpotifySong.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-01-19.
//

struct SpotifySong {
    let id: String
    let name: String
    let uri: String
    let duration: Int
    let artists: [String]
    let albumName: String
    let artworkURL: String
    var artworkImage: UIImage?
    
    init(song: Song) {
        self.id = song.id
        self.name = song.title
        self.uri = song.uri
        self.duration = 0
        self.artists = [""]
        self.albumName = ""
        self.artworkURL = song.artworkURL
    }

    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String else {
            print("Missing id")
            return nil
        }
        guard let name = dictionary["name"] as? String else {
            print("Missing name")
            return nil
        }
        guard let uri = dictionary["uri"] as? String else {
            print("Missing uri")
            return nil
        }
        guard let duration = dictionary["duration_ms"] as? Int else {
            print("Missing duration")
            return nil
        }
        guard let album = dictionary["album"] as? [String: Any],
              let albumName = album["name"] as? String else {
            print("Missing album or album name")
            return nil
        }
        guard let artistsArray = dictionary["artists"] as? [[String: Any]] else {
            print("Missing artists")
            return nil
        }
        guard let imageArray = album["images"] as? [[String: Any]],
            let firstImageJson = imageArray.first,
            let artworkURL = firstImageJson["url"] as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.uri = uri
        self.duration = duration
        self.albumName = albumName
        self.artists = artistsArray.compactMap { $0["name"] as? String }
        self.artworkURL = artworkURL
    }
}
