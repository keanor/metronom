//
//  ViewController.swift
//  Metronom
//
//  Created by Ширшов Александр on 19.12.2019.
//  Copyright © 2019 Ширшов Александр. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var rhythmStepper: StepperView!
    @IBOutlet weak var speedStepper: StepperView!
    @IBOutlet weak var metronomView: MetronomView!

    var timer = Timer()
    var timerIsRunning = false
    var shares = 0
    var bpm: Int {
        get { Int(speedStepper.valueText)! }
        set {
            if (newValue >= 60 || newValue <= 200) {
                metronomView.bpm = newValue
                speedStepper.valueText = String(newValue)
            }
        }
    }
    var takts: Int {
        get { metronomView.taktCount }
        set {
            if (newValue >= 2 && newValue <= 8) {
                metronomView.taktCount = newValue
                rhythmStepper.valueText = String(newValue) + "/4"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metronomView.translatesAutoresizingMaskIntoConstraints = false
 
        rhythmStepper.upHandler = { self.takts += 1 }
        rhythmStepper.downHandler = { self.takts -= 1 }
        
        speedStepper.upHandler = { self.bpm += 1 }
        speedStepper.downHandler = { self.bpm -= 1 }
        bpm = 120
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Вычисляем Y для MetronomView
        let minY = speedStepper.frame.maxY // выше этой точки подниматься нельзя
        var mY = view.frame.midY // Берем центр экрана
        mY -= TaktLineView.MAX_HEIGHT / 2 // Поднимаем на половину высоты черточек тактов
        if (mY < minY) {
            mY = minY
        }

        let padding: CGFloat = 40;
        let w: CGFloat = view.frame.width - padding * 2 // отступы
        let h: CGFloat = view.frame.height - mY - padding;

        metronomView.frame = CGRect(
            origin: CGPoint(
                    x: 40,
                    y: mY
            ),
            size: CGSize(
                    width: w,
                    height: h
            )
        )
    }
}
