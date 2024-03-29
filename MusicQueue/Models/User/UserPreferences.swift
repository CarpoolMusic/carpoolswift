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
        if let stringValue = userDefaults.string(forKey: musicServiceTypeKey),
           let rawValue = MusicServiceType(rawValue: stringValue) {
            return rawValue
        }
        return .unselected
    }
    
    static func setUserMusicService(type: MusicServiceType) {
        userDefaults.set(type.rawValue, forKey: musicServiceTypeKey)
    }
}
