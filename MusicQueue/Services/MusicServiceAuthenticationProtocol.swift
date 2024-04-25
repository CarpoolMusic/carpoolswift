/**
 This enum represents the different types of music services available.
 
 - apple: Represents the Apple Music service.
 - spotify: Represents the Spotify service.
 - unselected: Represents that no music service is selected.
 */
enum MusicServiceType: String, Codable {
    case apple, spotify, unselected
}

/**
 This protocol defines the authentication requirements for a music service.
 */
protocol MusicServiceAuthenticationProtocol: AnyObject {
    
    /**
     Determines whether the user is currently authenticated with the underlying music service.
     
     - Returns: The current authentication status of the user.
     */
    var authorizationStatus: MusicServiceAuthStatus { get }
    
    /**
     Indicates whether the user is authorized with the underlying music service.
     
     - Returns: A boolean value indicating whether the user is authorized or not.
     */
    var isAuthorized: Bool { get }
    
    /**
     Authorizes the user with the underlying music service.
     
     - Parameter authenticated: A closure that will be called once authentication is completed. The closure takes a boolean parameter indicating whether authentication was successful or not.
     */
    func authenticate(authenticated: @escaping ((Bool) -> (Void)))
}
