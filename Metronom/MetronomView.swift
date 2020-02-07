//
//  MetronomView.swift
//  Metronom
//
//  Created by Александр Ширшов on 30.12.2019.
//  Copyright © 2019 Ширшов Александр. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable
class MetronomView: UIView {
    let player = SoundPlayer()
    
    var startText: String { NSLocalizedString("bundle.start", comment: "") }
    var stopText: String { NSLocalizedString("bundle.stop", comment: "") }

    var beatCount: Int = 3 {
        didSet {
            createBeats()
        }
    }
    private let mainButton = UIButton()
    private var beats = [BeatLineView]()
    var bpm: Int = 60 {
        didSet {
            if (isRunning) {
                needReSchedule = true
            }
        }
    }

    var timer = Timer()
    private var isRunning = false
    private var needReSchedule = false
    private var nextBeatIndex = 0;
    private var lastCurrent: BeatLineView?;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    @objc func buttonHandle(sender: UIButton!) {
        if (isRunning) {
            timer.invalidate()
            nextBeatIndex = 0
            isRunning = false
            lastCurrent?.state = .enabled
            mainButton.setTitle(startText, for: .normal)
        } else {
            schedule()
            mainButton.setTitle(stopText, for: .normal)
            isRunning = true
        }
    }

    private func schedule() {
        let delay = 60.0/Double(bpm)
        timer.invalidate()
        timer = Timer.scheduledTimer(
                timeInterval: delay,
                target: self,
                selector: #selector(nextTaktHandler),
                userInfo: nil,
                repeats: true
        )
    }

    @objc private func nextTaktHandler() {
        // Ищем предыдущий чтобы убрать у него active
        lastCurrent?.state = .enabled

        // Получаем следующий элемент
        let current = beats[nextBeatIndex]
        if (current.state == .enabled) {
            // если он включен то делаем его текущим
            current.state = .current
            lastCurrent = current
            if (nextBeatIndex == 0) {
                player.playFirst()
            } else {
                player.playOther()
            }
        }
        nextBeatIndex += 1
        if (nextBeatIndex > beats.endIndex - 1) {
            nextBeatIndex = 0
        }

        if (needReSchedule) {
            schedule()
            needReSchedule = false
        }
    }

    func setupViews() {
        mainButton.backgroundColor = UIColor(red: 0.365, green: 0.733, blue: 0.561, alpha: 1)
        mainButton.setTitle(startText, for: .normal)
        mainButton.addTarget(self, action: #selector(buttonHandle), for: .touchUpInside)
        addSubview(mainButton)

        createBeats()
    }
    
    func createBeats() {
        for view in beats {
            view.removeFromSuperview()
        }
        beats.removeAll()
        for _ in 0...(beatCount - 1) {
            let beatView = BeatLineView(state: .enabled);
            addSubview(beatView)
            beats.append(beatView)
        }
        bringSubviewToFront(mainButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutMainButton()
        
        // Радиус от центра кнопки до самого верха
        let radius = mainButton.frame.minY + mainButton.frame.height / 2
        let horda = frame.width
        
        var index = 0;
        for view in beats {
            view.layoutInParent(index: index, total: beatCount, horda: horda, radius: radius)
            index += 1
        }
    }
    
    private func layoutMainButton() {
        let buttonWidth: CGFloat = 128
        let buttonHeight: CGFloat = 128
        
        mainButton.frame = CGRect(
            origin: CGPoint(
                x: bounds.midX - buttonWidth / 2, // center
                y: bounds.height - buttonHeight // bottom
            ),
            size: CGSize (
                width: buttonWidth,
                height: buttonHeight
            )
        )
        mainButton.layer.cornerRadius = 0.5 * buttonWidth
        mainButton.clipsToBounds = true
    }
}
