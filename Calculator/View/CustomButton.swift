//
//  CustomButton.swift
//  Calculator
//
//  Created by Sylvain Druaux on 30/12/2022.
//

import UIKit

@IBDesignable class CustomButton: UIButton {
    private lazy var normalTitleColor = titleColor(for: .normal)
    private lazy var normalBackgroundColor = backgroundColor
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                // Invert title and background colors
                setBackgroundColor(color: normalTitleColor!, forState: .selected)
                setTitleColor(normalBackgroundColor, for: .selected)
                tintColor = UIColor.clear
            }
        }
    }
    
    // https://stackoverflow.com/questions/38874517/how-to-make-a-simple-rounded-button-in-storyboard
    override func layoutSubviews() {
        super.layoutSubviews()

        updateCornerRadius()
    }

    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    private func updateCornerRadius() {
        // If rounded is true, cornerRadius is set to half ( height / 2 ), otherwise, cornerRadius is set to 0 (the layer remains a square).
        // This code snippet is similar to: if rounded { layer.cornerRadius = frame.size.height / 2 } else { layer.cornerRadius = 0 }
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}
