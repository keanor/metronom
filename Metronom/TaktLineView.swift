//
//  TaktLineView.swift
//  Metronom
//
//  Created by Александр Ширшов on 30.12.2019.
//  Copyright © 2019 Ширшов Александр. All rights reserved.
//

import UIKit

class TaktLineView: UIView {
    private var disabledLayer = UIView()
    private var enabledLayer = UIView()
    private var currentLayer = UIView()
    
    enum State {
        case disabled
        case enabled
        case current
    }
    
    var state: State = .disabled {
        didSet {
            setupLayer(state: state)
        }
    }
    
    convenience init(state: State) {
        self.init(frame: .zero)
        self.state = state
        
        setupDisabledLayer()
        setupEnabledLayer()
        setupCurrentLayer()
        
        setupLayer(state: state)
    }
    
    private func setupLayer(state: State) {
        enabledLayer.removeFromSuperview()
        let enabledTap = UITapGestureRecognizer(target: self, action: #selector(self.disable))
        enabledLayer.addGestureRecognizer(enabledTap)
        enabledLayer.isUserInteractionEnabled = true
        
        disabledLayer.removeFromSuperview()
        let disabledTap = UITapGestureRecognizer(target: self, action: #selector(self.enable))
        disabledLayer.addGestureRecognizer(disabledTap)
        disabledLayer.isUserInteractionEnabled = true
        
        currentLayer.removeFromSuperview()
        
        switch state {
        case .disabled:
            addSubview(disabledLayer)
        case .enabled:
            addSubview(enabledLayer)
        case .current:
            addSubview(currentLayer)
            addSubview(enabledLayer)
        }
    }
    
    @objc func disable() {
        state = .disabled
    }
    
    @objc func enable() {
        state = .enabled
    }
    
    private func setupDisabledLayer() {
        disabledLayer.frame = CGRect(x: 6, y: 2, width: 8, height: 57)
        disabledLayer.backgroundColor = .white
        disabledLayer.layer.backgroundColor = UIColor(red: 0.817, green: 0.875, blue: 0.848, alpha: 1).cgColor
        disabledLayer.layer.cornerRadius = 4
        disabledLayer.layer.borderWidth = 2
        disabledLayer.layer.borderColor = UIColor(red: 0.906, green: 0.958, blue: 0.934, alpha: 1).cgColor
    }
    
    private func setupEnabledLayer() {
        enabledLayer.frame = CGRect(x: 6, y: 2, width: 8, height: 57)
        enabledLayer.backgroundColor = .white
        
        let shadows = UIView()
        shadows.frame = enabledLayer.frame
        shadows.clipsToBounds = false
        enabledLayer.addSubview(shadows)

        let shadowLayer = CALayer()
        shadowLayer.shadowPath = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 4).cgPath
        shadowLayer.shadowColor = UIColor(red: 0.356, green: 0.929, blue: 0.551, alpha: 1).cgColor
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 26
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer.bounds = shadows.bounds
        shadowLayer.position = shadows.center
        enabledLayer.layer.addSublayer(shadowLayer)

        enabledLayer.layer.backgroundColor = UIColor(red: 0.365, green: 0.733, blue: 0.561, alpha: 1).cgColor
        enabledLayer.layer.cornerRadius = 4
        enabledLayer.layer.borderWidth = 2
        enabledLayer.layer.borderColor = UIColor(red: 0.68, green: 0.938, blue: 0.954, alpha: 1).cgColor
    }
    
    private func setupCurrentLayer() {
        currentLayer.frame = CGRect(x: 4, y: 0, width: 12, height: 61)
        currentLayer.backgroundColor = .white
        currentLayer.layer.cornerRadius = 6
        currentLayer.layer.borderWidth = 2
        currentLayer.layer.borderColor = UIColor(red: 0.365, green: 0.733, blue: 0.561, alpha: 1).cgColor
    }
    
    public func layoutInParent(index: Int, total: Int, horda: CGFloat, radius: CGFloat) {
        // Размер дуги в градусах: а = 2arcsin(с/2R) где c - длина хорды
        let angle = 2 * asin(horda / (2 * radius))
        
        // Расчитываем размер виртуальной линии от центра кнопки до верхнего контейнера
        let taktViewWidth: CGFloat = 20;
        if (frame.width == 0.0) {
            layer.anchorPoint = CGPoint(x: 1, y: 1)
            frame = CGRect(
                origin: CGPoint(
                    x: horda/2 - taktViewWidth / 2,
                    y: 0
                ),
                size: CGSize(
                    width: taktViewWidth,
                    height: radius
                )
            )
            
            let angleStep = angle / CGFloat(total - 1); // Шаг
            let firstRadians = CGFloat(angle / 2) * -1 // Угол для первого такта
            let radians = firstRadians + angleStep * CGFloat(index)
            transform = CGAffineTransform(rotationAngle: radians )
        }
    }
}
