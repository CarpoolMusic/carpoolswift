//
//  MusicServiceAuthenticationProtocol.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-25.
//

//
//  MusicService.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-12.
//

import SwiftUI
import Combine
import MusicKit

enum MusicServiceType: String {
    case apple, spotify, unselected
}

protocol MusicServiceAuthenticationProtocol: AnyObject {
    /// determines whether the user is currently authenticated with the underlying music service
    var authorizationStatus: MusicServiceAuthStatus { get }
    
    var isAuthorized: Bool { get }
    
    /// authorizes the user with the underlying music service
    func authenticate(authenticated: @escaping ((Bool) -> (Void)))
}
