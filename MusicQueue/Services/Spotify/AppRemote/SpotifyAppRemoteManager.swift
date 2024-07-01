import SpotifyiOS

protocol SpotifyAppRemoteManagerProtocol {
    var appRemote: SPTAppRemote { get }
    var playerState: SPTAppRemotePlayerState? { get }
    
    func isConnected() -> Bool
    func connect(with songUri: String) -> Void
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState)
}

class SpotifyAppRemoteManager: NSObject, SpotifyAppRemoteManagerProtocol, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    
    // MARK: - Properties
    @Injected private var logger: CustomLoggerProtocol
    
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
        guard let data = KeychainHelper.standard.read(service: "com.poles.carpoolapp", account: "spotifyToken") else {
            logger.error("Unable to fetch access token")
            return appRemote
        }
        appRemote.connectionParameters.accessToken = String(data: data, encoding: .utf8)
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
                guard let data = KeychainHelper.standard.read(service: "com.poles.carpoolapp", account: "spotifyToken") else {
                    self.logger.error("Unable to read access token")
                    return
                }
                self.appRemote.connectionParameters.accessToken = String(data: data, encoding: .utf8)
                self.appRemote.connect()
                self.appRemote.authorizeAndPlayURI(songUri)
            }
        }
    }
    
    func isConnected() -> Bool {
        return appRemote.isConnected
    }
    
    // MARK: - SPTAppRemoteDelegate
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("APP REMOTE Connection established")
        
        self.connected = true
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                print("Error subscribing to player state:", error.localizedDescription)
            }
        })
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("Connection attempt failed with error \(String(describing: error))")
        self.connected = false
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("Session disconnected")
        self.connected = false
    }
    
    // MARK: - SPTAppRemotePlayerStateDelegate
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("PLAYER STATE CHANGED")
        self.playerState = playerState
    }
}
