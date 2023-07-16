//
//  SessionManagerProtocol.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-07-16.
//

protocol SessionManagerProtocol: AnyObject {
    func handleEvent(_ event: SocketEvent)
    func handleError(_ error: SocketError)
}
