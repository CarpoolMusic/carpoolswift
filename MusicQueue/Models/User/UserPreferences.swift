//
//  UserPreferences.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-08-11.
//

class UserPreferences {
    private static let userDefaults = UserDefaults.standard
    private static let musicServiceTypeKey = "musicServiceType"
    
    static func getUserMusicService() -> MusicServiceType {
        return userDefaults.object(forKey: musicServiceTypeKey) as? MusicServiceType ?? .unselected
    }
    
    static func setUserMusicService(type: MusicServiceType) {
        userDefaults.set(type.rawValue, forKey: musicServiceTypeKey)
    }
}
