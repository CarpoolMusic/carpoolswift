//
//  ServiceSessionManagerProtocol.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-10-07.
//

import Foundation
protocol ServiceSessionManagerProtocol {
    
    func initiateSession(scope: SPTScope, authenticated: @escaping ((Bool) -> (Void)))
    func returnFromURL(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Void
}
