import MusicKit
/**
 This struct represents a song from Apple Music.
 
 - Parameters:
    - song: The MusicKit.Song object representing the song.
 */
struct AppleMusicSong {
    
    private let song: MusicKit.Song
    
    /**
     Initializes an AppleMusicSong object with a MusicKit.Song object.
     
     - Parameters:
        - song: The MusicKit.Song object representing the song.
     */
    init(_ song: MusicKit.Song) {
        self.song = song
    }
    
    /// The unique identifier of the song.
    var id: MusicItemID = MusicItemID("0")
    
    /// The number of votes received for the song.
    var votes: Int = 0
    
    /// The title of the song.
    var title: String { song.title }
    
    /// The artist of the song.
    var artist: String { song.artistName }
    
    /// The album of the song. If not available, it will be an empty string.
    var album: String { song.albumTitle ?? "" }
    
    /// The duration of the song in seconds. If not available, it will be 0.
    var duration: TimeInterval { song.duration ?? 0 }
    
    /// The URL of the audio file for streaming or downloading the song.
    var uri: URL { song.url! }
    
    /// The URL of the artwork image for the artist or album associated with the song.
    var artworkURL: URL { song.artistURL! }
    
   /**
     Converts the AppleMusicSong object to JSON data representation.

     - Returns:
        JSON data representation of the AppleMusicSong object.

     - Throws:
        An error if encoding fails.

   */
   func toJSONData() throws -> Data {
       let encodableSong = EncodableGenericSong(
           id: id.rawValue,
           votes: votes,
           title: title,
           artist: artist,
           album: album,
           duration: duration,
           uri: uri
       )
       
       return try JSONEncoder().encode(encodableSong)
   }
}
