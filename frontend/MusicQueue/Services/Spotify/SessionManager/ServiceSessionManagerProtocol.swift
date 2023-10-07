//
//  ServiceSessionManagerProtocol.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-10-07.
//

import Foundation
protocol ServiceSessionManagerProtocol {
    
    func initiateSession(scope: SPTScope)
    func notifyReturnFromAuth(url: URL)
}
