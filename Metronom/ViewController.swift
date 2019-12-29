//
//  ViewController.swift
//  Metronom
//
//  Created by Ширшов Александр on 19.12.2019.
//  Copyright © 2019 Ширшов Александр. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timer = Timer()
    var timerIsRunning = false
    var shares = 0
    var bpm: Int {
        get { Int(speedStepper.valueText)! }
        set {
            if (newValue >= 60 || newValue <= 200) {
                speedStepper.valueText = String(newValue)
            }
        }
    }
    
    @IBOutlet weak var speedStepper: SlideStepper!
    @IBOutlet weak var firstTakt: UIImageView!
    @IBOutlet weak var secondTakt: UIImageView!
    @IBOutlet weak var thirdTakt: UIImageView!
    @IBOutlet weak var stopButtonOutlet: UIButton!
    @IBOutlet weak var playButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        firstTakt.isHidden = true
        secondTakt.isHidden = true
        thirdTakt.isHidden = true
        
        playButtonOutlet.isHidden = false
        stopButtonOutlet.isHidden = true
        
        speedStepper.upHandler = {
            if (self.bpm < 200) {
                self.bpm += 1
            }
        }
        
        speedStepper.downHandler = {
            if (self.bpm > 60) {
                self.bpm -= 1
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func runButton() {
        runTimer()
        playButtonOutlet.isHidden = true
        stopButtonOutlet.isHidden = false
    }
    
    @IBAction func stopButton() {
        timer.invalidate()
        playButtonOutlet.isHidden = false
        stopButtonOutlet.isHidden = true
        firstTakt.isHidden = true
        secondTakt.isHidden = true
        thirdTakt.isHidden = true
        shares = 0
    }

    func runTimer() {
        let times = 60.0/Double(bpm)
        timer = Timer.scheduledTimer(timeInterval: times, target: self, selector: (#selector(timerUpdate)), userInfo: nil, repeats: true)
    }
    
    @objc func timerUpdate() {
        if shares > 2 {
            shares = 0
        }
        
        shares += 1
        
        switch shares {
        case 1:
            firstTakt.isHidden = false
            secondTakt.isHidden = true
            thirdTakt.isHidden = true
        case 2:
            firstTakt.isHidden = true
            secondTakt.isHidden = false
            thirdTakt.isHidden = true
        case 3:
            firstTakt.isHidden = true
            secondTakt.isHidden = true
            thirdTakt.isHidden = false
        default:
            break
        }
    }
}
