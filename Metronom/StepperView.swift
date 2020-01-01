//
//  SlideStepper.swift
//  Metronom
//
//  Created by Александр Ширшов on 24.12.2019.
//  Copyright © 2019 Александр Ширшов. All rights reserved.
//

import UIKit

@IBDesignable
class StepperView: UIView {
    
    private let upButton = StepperView.Button(direction: .up)
    private let contentBox = StepperView.ContentBox()
    private let downButton = StepperView.Button(direction: .down)
    
    @IBInspectable
    var nameText: String = "" {
        didSet {
            contentBox.nameLabel.text = nameText
            contentBox.setNeedsLayout()
        }
    }
    
    @IBInspectable
    var valueText: String = "" {
        didSet {
            contentBox.valueLabel.text = valueText
            contentBox.setNeedsLayout()
        }
    }
    
    var upHandler: () -> Void = {}
    var downHandler: () -> Void = {}
    
    override open var intrinsicContentSize: CGSize {
        CGSize(width: 100, height: 142)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        // кнопка "вверх"
        addSubview(upButton)
        upButton.translatesAutoresizingMaskIntoConstraints = true
        upButton.addTarget(self, action: #selector(upButtonTapped), for: .touchUpInside)
        
        // текстовый бокс в середине
        addSubview(contentBox)
        contentBox.translatesAutoresizingMaskIntoConstraints = true
        
        // кнопка "вниз"
        addSubview(downButton)
        downButton.translatesAutoresizingMaskIntoConstraints = true
        downButton.addTarget(self, action: #selector(downButtonTapped), for: .touchUpInside)
    }
    
    @objc func upButtonTapped() {
        upHandler()
    }
    
    @objc func downButtonTapped() {
        downHandler()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        var nextY = push(view: upButton, y: 0)
        nextY = push(view: contentBox, y: nextY)
        nextY = push(view: downButton, y: nextY)
    }
    
    private func push(view: UIView, y: CGFloat) -> CGFloat {
        let size = view.intrinsicContentSize
        view.frame = CGRect(
            origin: CGPoint(
                x: bounds.maxX/2 - size.width/2,
                y: y
            ),
            size: size
        )
        
        return y + size.height + 16 // return y for next element
    }
    
    private class Button: UIButton {
        enum Direction: String {
            case up = "button-up"
            case down = "button-down"
        }
        
        override open var buttonType: UIButton.ButtonType {
            .custom
        }
        
        override open var intrinsicContentSize: CGSize {
            CGSize(width: 32, height: 22)
        }
        
        convenience init(direction: Direction) {
            self.init(frame: .zero)
            
            let bundle = Bundle(for: StepperView.self)
            let loadedImage = UIImage(named: direction.rawValue, in: bundle, compatibleWith: nil)
            if let image = loadedImage {
                setTitle(direction.rawValue, for: .normal)
                setImage(image, for: .normal)
                imageView?.contentMode = .center
            } else {
                print("Unable load image with name: " + direction.rawValue)
            }
        }
    }
    
    private class ContentBox: UIView {
        private let nameColor = UIColor(red: 0.578, green: 0.708, blue: 0.648, alpha: 1)
        private let valueColor = UIColor(red: 0.192, green: 0.246, blue: 0.22, alpha: 1)
        
        let nameLabel = UILabel()
        let valueLabel = UILabel()
        
        override open var intrinsicContentSize: CGSize {
            CGSize(width: 100, height: 66)
        }
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupView()
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }
        
        private func setupView() {
            addSubview(nameLabel)
            nameLabel.translatesAutoresizingMaskIntoConstraints = true
            nameLabel.textColor = nameColor
            nameLabel.font = loadFont(family: "SFProText-Semibold", size: 15)
            
            addSubview(valueLabel)
            valueLabel.translatesAutoresizingMaskIntoConstraints = true
            valueLabel.textColor = valueColor
            valueLabel.font = loadFont(family: "SFProText-Medium", size: 42)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let nameLabelSize = nameLabel.intrinsicContentSize
            nameLabel.frame = CGRect(
                origin: CGPoint(
                    x: bounds.maxX/2 - nameLabelSize.width/2,
                    y: 0
                ),
                size: nameLabelSize
            )
            
            let valueLabelSize = valueLabel.intrinsicContentSize
            valueLabel.frame = CGRect(
                origin: CGPoint(
                    x: bounds.maxX/2 - valueLabelSize.width/2,
                    y: nameLabelSize.height
                ),
                size: valueLabelSize
            )
        }
        
        private func loadFont(family: String, size: CGFloat) -> UIFont {
            guard let font = UIFont(name: family, size: size) else {
                fatalError("""
                    Failed to load the "\(family)" font.
                    """
                )
            }
            
            return font
        }
    }
}

