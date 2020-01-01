//
//  SoundPlayer.swift
//  Metronom
//
//  Created by Александр Ширшов on 02.01.2020.
//  Copyright © 2020 Ширшов Александр. All rights reserved.
//

import Foundation
import AVFoundation

class SoundPlayer {
    private var firstSound: AVAudioPlayer!
    private var otherSound: AVAudioPlayer!

    init() {
        firstSound = loadPlayer(name: "k1.wav")
        firstSound?.prepareToPlay()
        otherSound = loadPlayer(name: "k2.wav")
        otherSound?.prepareToPlay()
    }

    private func loadPlayer(name: String) -> AVAudioPlayer? {
        let resource = Bundle.main.path(forResource: name, ofType: nil)
        guard let file = resource else  {
            print("Unable load resource: " + name)
            return nil
        }

        do {
            return try AVAudioPlayer(contentsOf: URL(fileURLWithPath: file))
        } catch {
            print("Unable create AVAudioPlayer: " + error.localizedDescription)
            return nil
        }
    }

    func playFirst() {
        play(player: firstSound!)
    }

    func playOther() {
        play(player: otherSound!)
    }

    private func play(player: AVAudioPlayer) {
        if (player.isPlaying) {
            player.stop()
        }
        player.play()
    }
}