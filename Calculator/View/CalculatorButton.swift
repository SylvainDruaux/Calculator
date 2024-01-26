//
//  CalculatorButton.swift
//  Calculator
//
//  Created by Sylvain Druaux on 30/12/2022.
//

import UIKit

@IBDesignable class CalculatorButton: UIButton {
    // MARK: - Properties

    @IBInspectable var rounded: Bool = false { didSet { updateCornerRadius() } }

    override var isSelected: Bool { didSet { handleBasedIsSelected() } }

    private var originalBackgroundColor: UIColor?
    private var originalTitleColor: UIColor?
    private var animator = UIViewPropertyAnimator()

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }

    // MARK: - Actions

    @objc func touchDown() {
        stopAnimation(true)
        backgroundColor = originalBackgroundColor?.lighter(by: 15)
    }

    @objc func touchUp() {
        setupAnimator()
        startAnimation()
    }
}

// MARK: - View

private extension CalculatorButton {
    func setup() {
        tintColor = .clear
        saveBackgroundColor()
        saveTitleColor()
        setupInteraction()
    }

    func setupInteraction() {
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
    }

    func startAnimation() {
        animator.startAnimation()
    }

    func stopAnimation(_ bool: Bool) {
        animator.stopAnimation(bool)
    }

    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }

    func setupAnimator() {
        animator = isSelected ?
            initAnimator(with: updateWhenIsSelected) :
            initAnimator(with: updateWhenIsDeselected)
    }

    func updateWhenIsSelected() {
        backgroundColor = originalTitleColor
        setTitleColor(originalBackgroundColor, for: .selected)
    }

    func updateWhenIsDeselected() {
        setTitleColor(originalTitleColor, for: .normal)
        backgroundColor = originalBackgroundColor
    }

    func handleBasedIsSelected() {
        if animator.isRunning { stopAnimation(true) }
        updateBasedIsSelected()
    }

    func updateBasedIsSelected() {
        setupAnimator()
        startAnimation()
    }

    func saveBackgroundColor() {
        originalBackgroundColor = backgroundColor ?? .clear
    }

    func saveTitleColor() {
        originalTitleColor = titleColor(for: .normal)
    }

    func initAnimator(with animation: (() -> Void)?) -> UIViewPropertyAnimator {
        UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: animation)
    }
}
