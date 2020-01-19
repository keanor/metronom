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
        get { metronomView.beatCount }
        set {
            if (newValue >= 2 && newValue <= 8) {
                metronomView.beatCount = newValue
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

        let padding: CGFloat = 40;

        // если над кнопкой степперов нет, то поднимаем до начала степперов
        let beatSize = rhythmStepper.frame
        let bpmSize = speedStepper.frame
        
        let mtrSize = metronomView.frame
        if mtrSize.minX > beatSize.maxX && mtrSize.maxX < bpmSize.minX {
            metronomView.frame = CGRect(
                origin: CGPoint(
                    x: mtrSize.minX,
                    y: padding
                ), size: CGSize(
                    width: mtrSize.width,
                    height: mtrSize.maxY - padding
                )
            )
        } else {
            // Вычисляем Y для MetronomView
            let minY = speedStepper.frame.maxY // выше этой точки подниматься нельзя
            var mY = view.frame.midY // Берем центр экрана
            mY -= BeatLineView.MAX_HEIGHT / 2 // Поднимаем на половину высоты черточек тактов
            if (mY < minY) {
                mY = minY
            }

            let w: CGFloat = view.frame.width - padding * 2 // отступы
            let h: CGFloat = view.frame.height - mY - padding;

            metronomView.frame = CGRect(
                origin: CGPoint(
                        x: padding,
                        y: mY
                ),
                size: CGSize(
                        width: w,
                        height: h
                )
            )
        }
    }
}
