//
//  UserSettings.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-04-27.
//

import Foundation

protocol UserSettingsProtocol{
    var musicServiceType: MusicServiceType { get set }
}

class UserSettings: UserSettingsProtocol {
    var musicServiceType: MusicServiceType = .unselected
}
