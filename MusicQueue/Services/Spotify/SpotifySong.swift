// MARK: - CodeAI Output
/**
 A struct representing a song from Spotify.
 
 - Parameters:
    - id: The unique identifier of the song.
    - name: The name of the song.
    - uri: The URI of the song.
    - duration: The duration of the song in milliseconds.
    - artists: An array of artist names associated with the song.
    - albumName: The name of the album that the song belongs to.
    - artworkURL: The URL of the artwork image for the song.
    - artworkImage: An optional UIImage object representing the artwork image for the song.
 */
struct SpotifySong {
    
    let id: String
    let name: String
    let uri: String
    let duration: Int
    let artists: [String]
    let albumName: String
    let artworkURL: String
    var artworkImage: UIImage?
    
    /**
     Initializes a SpotifySong object using a Song object as input.
     
     - Parameter song: A Song object containing information about the song.
     */
    init(song: Song) {
        self.id = song.id
        self.name = song.title
        self.uri = song.uri
        self.duration = 0
        self.artists = [""]
        self.albumName = ""
        self.artworkURL = song.artworkUrl
    }
    
   /**
     Initializes a SpotifySong object using a dictionary representation of its properties.
     
     - Parameter dictionary: A dictionary containing key-value pairs representing the properties of a SpotifySong object. The keys should match the property names and types defined in this struct.
     
     - Returns:
     A new instance of SpotifySong if all required data is present in the dictionary, otherwise returns nil and prints an error message indicating missing data.
   */
   init?(dictionary: [String : Any]) {
       guard let id = dictionary["id"] as? String,
             let name = dictionary["name"] as? String,
             let uri = dictionary["uri"] as? String,
             let duration = dictionary["duration_ms"] as? Int,
             let album = dictionary["album"] as? [String: Any],
             let albumName = album["name"] as? String,
             let artistsArray = dictionary["artists"] as? [[String: Any]],
             let imageArray = album["images"] as? [[String: Any]],
             let firstImageJson = imageArray.first,
             let artworkURL = firstImageJson["url"] as? String else {
           print("Missing required data")
           return nil
       }
       
       self.id = id
       self.name = name
       self.uri = uri
       self.duration = duration
       self.albumName = albumName
       
       if artistsArray.isEmpty {
           print("Missing artists")
           return nil
       } else {
           self.artists = artistsArray.compactMap { $0["name"] as? String }
       }
       
       self.artworkURL = artworkURL
   }
}
