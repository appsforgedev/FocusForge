//
//  AudioManager.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 15.05.2025.
//


import Foundation
import AVFoundation

final class AudioManager {
    
    private let settingsStore: SettingsStore
    private var player: AVAudioPlayer?
    
    init(settingsStore: SettingsStore) {
        self.settingsStore = settingsStore
    }

    enum AppSound: String {
        case startFocus = "forge_ignite"
        case endFocus = "hammer_strike"
        case startShortBreak = "coal_crackle"
        case endShortBreak = "anvil_ring"
        case startLongBreak = "embers_fade"
        case endLongBreak = "forge_awaken"
        case pause = "pause"
        case resume = "flame_whip"
        case reset = "metal_reset"
        case tick = "tick"
        case hit = "hit"
        case click = "click"
        case final = "steam_release"
    }

    func play(_ sound: AppSound) {
        guard settingsStore.isSoundEnabled else { return }
        
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "wav") else {
            print("🔇 Sound not found: \(sound.rawValue)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("🔇 Error playing sound: \(error)")
        }
    }
}
