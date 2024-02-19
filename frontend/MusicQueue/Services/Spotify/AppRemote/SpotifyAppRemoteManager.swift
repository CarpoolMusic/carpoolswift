/**
 This class manages the Spotify app remote functionality. It handles connecting to the Spotify app, authorizing and playing a song, and subscribing to player state updates.
 */
class SpotifyAppRemoteManager: NSObject, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    
    // MARK: - Properties
    
    private let SpotifyClientID = "61c4e261fe3348b7baa6dbf27879f865"
    private let SpotifyRedirectURL = URL(string: "music-queue://login-callback")!
    
    private var connected: Bool = false
    var playerState: SPTAppRemotePlayerState?
    
    lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = TokenVault.getTokenFromKeychain()
        appRemote.delegate = self
        return appRemote
    }()
    
    // MARK: - Public Methods
    
    /**
     Connects to the Spotify app and plays the specified song.
     
     - Parameters:
       - songUri: The URI of the song to play.
     */
    func connect(with songUri: String) {
        DispatchQueue.main.async {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.appRemote.connectionParameters.accessToken = TokenVault.getTokenFromKeychain()
                self.appRemote.connect()
                self.appRemote.authorizeAndPlayURI(songUri)
            }
        }
    }
    
    // MARK: - SPTAppRemoteDelegate
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("APP REMOTE Connection established")
        
        connected = true
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                print("Error subscribing to player state:", error.localizedDescription)
            }
        })
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("Connection attempt failed with error \(String(describing: error))")
        connected = false
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("Session disconnected")
        connected = false
    }
    
    // MARK: - SPTAppRemotePlayerStateDelegate
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("PLAYER STATE CHANGED")
        self.playerState = playerState
    }
}
