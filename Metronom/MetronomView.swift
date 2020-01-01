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

    var taktCount: Int = 3 {
        didSet {
            createTaktViews()
        }
    }
    private let mainButton = UIButton()
    private var taktViews = [TaktLineView]()
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
    private var nextTakt = 0;
    private var lastCurrent: TaktLineView?;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    @objc func buttonHandle() {
        if (isRunning) {
            timer.invalidate()
            nextTakt = 0
            isRunning = false
            lastCurrent?.state = .enabled
            mainButton.setTitle("START", for: .normal)
        } else {
            schedule()
            mainButton.setTitle("STOP", for: .normal)
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
        let lastTakt = taktViews.endIndex - 1
        if (nextTakt > lastTakt) {
            nextTakt = 0
        }

        // Ищем предыдущий чтобы убрать у него active
        lastCurrent?.state = .enabled

        // Получаем следующий элемент
        let current = taktViews[nextTakt]
        if (current.state == .enabled) {
            // если он включен то делаем его текущим
            current.state = .current
            lastCurrent = current
            if (nextTakt == 0) {
                player.playFirst()
            } else {
                player.playOther()
            }
        }
        nextTakt += 1

        if (needReSchedule) {
            schedule()
            needReSchedule = false
        }
    }


    
    func setupViews() {
        mainButton.backgroundColor = UIColor(red: 0.365, green: 0.733, blue: 0.561, alpha: 1)
        mainButton.setTitle("START", for: .normal)
        mainButton.addTarget(self, action: #selector(buttonHandle), for: .touchUpInside)
        addSubview(mainButton)
        
        createTaktViews()
    }
    
    func createTaktViews() {
        for view in taktViews {
            view.removeFromSuperview()
        }
        taktViews.removeAll()
        for _ in 0...(taktCount - 1) {
            let taktView = TaktLineView(state: .enabled);
            addSubview(taktView)
            taktViews.append(taktView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutMainButton()
        
        // Радиус от центра кнопки до самого верха
        let radius = mainButton.frame.minY + mainButton.frame.height / 2
        let horda = frame.width
        
        var index = 0;
        for view in taktViews {
            view.layoutInParent(index: index, total: taktCount, horda: horda, radius: radius)
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
