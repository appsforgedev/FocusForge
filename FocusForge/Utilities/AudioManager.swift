//
//  AudioManager.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 15.05.2025.
//


import Foundation
import AVFoundation
import Combine

final class AudioManager {
    static let shared = AudioManager()
    
    @Published var isSoundEnabled: Bool = true

    private var player: AVAudioPlayer?
    private var cancellable: AnyCancellable?
    
    private init() {
        // Подпишемся на обновление из SettingsStore
        cancellable = SettingsStore.shared.$settings
            .map(\.isSoundEnabled)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: \.isSoundEnabled, on: self)
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
        case final = "steam_release"
    }

    func play(_ sound: AppSound) {
        guard isSoundEnabled else { return }
        
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
