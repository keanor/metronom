//
//  SoundPlayer.swift
//  Metronom
//
//  Created by Александр Ширшов on 02.01.2020.
//  Copyright © 2020 Ширшов Александр. All rights reserved.
//

import Foundation
import AVFoundation
import ModernAVPlayer

class SoundPlayer {
    private var firstSound: ModernAVPlayer?
    private var otherSound: ModernAVPlayer?

    init() {
        firstSound = loadPlayer(name: "sounds/k1.wav")
        otherSound = loadPlayer(name: "sounds/k2.wav")
    }

    private func loadPlayer(name: String) -> ModernAVPlayer? {
        guard let resource = Bundle.main.url(forResource: name, withExtension: nil) else {
            print("Unable load resource with name " + name)
            return nil
        }
        let media = ModernAVPlayerMedia(url: resource, type: .clip)
        let player = ModernAVPlayer()
        player.load(media: media, autostart: false)

        return player
    }

    func playFirst() {
        firstSound!.stop()
        firstSound!.seek(offset: 0)
        firstSound!.play()
    }

    func playOther() {
        otherSound!.stop()
        otherSound!.seek(offset: 0)
        otherSound!.play()
    }
}
