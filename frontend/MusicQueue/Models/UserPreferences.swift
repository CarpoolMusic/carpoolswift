//
//  UserPreferences.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-08-11.
//

class UserPreferences {
    private let userDefaults = UserDefaults.standard
    private let musicServiceTypeKey = "musicServiceType"
    
    var selectedMusicServiceType: MusicServiceType {
        get {
            getSelectedMusicService(musicServiceTypeKey: musicServiceTypeKey)
        }
        set {
            setSelectedMusicService(musicServiceType: newValue)
        }
    }
    
    // gets the selected music service from user defaults
    private func getSelectedMusicService(musicServiceTypeKey: String) -> MusicServiceType {
        if let stringValue = userDefaults.string(forKey: musicServiceTypeKey),
           let rawValue = MusicServiceType(rawValue: stringValue) {
            return rawValue
        }
        return .unselected
    }
    
    // sets the selected music service and saves to user defaults
    private func setSelectedMusicService(musicServiceType: MusicServiceType) {
        userDefaults.set(musicServiceType.rawValue, forKey: musicServiceTypeKey)
    }
}
