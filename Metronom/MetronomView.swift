//
//  MetronomView.swift
//  Metronom
//
//  Created by Александр Ширшов on 30.12.2019.
//  Copyright © 2019 Ширшов Александр. All rights reserved.
//

import UIKit

@IBDesignable
class MetronomView: UIView {
    var taktCount: Int = 3 {
        didSet {
            createTaktViews()
        }
    }
    private let mainButton = UIButton()
    private var taktViews = [TaktLineView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupViews() {
        mainButton.backgroundColor = UIColor(red: 0.365, green: 0.733, blue: 0.561, alpha: 1)
        mainButton.setTitle("START", for: .normal)
        addSubview(mainButton)
        
        createTaktViews()
    }
    
    func createTaktViews() {
        for view in taktViews {
            view.removeFromSuperview()
        }
        taktViews.removeAll()
        for _ in 0...(taktCount - 1) {
            let taktView = TaktLineView(state: .current);
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
