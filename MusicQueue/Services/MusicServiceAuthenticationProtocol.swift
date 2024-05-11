import SwiftUI

enum MusicServiceType: String, Codable {
    case apple, spotify, unselected
}

protocol MusicServiceAuthenticationProtocol: AnyObject {
    
    var authorizationStatus: MusicServiceAuthStatus { get }
    
    var isAuthorized: Bool { get }
    
    func authenticate(authenticated: @escaping ((Bool) -> (Void)))
}
