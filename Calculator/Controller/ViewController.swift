//
//  ViewController.swift
//  Calculator
//
//  Created by Sylvain Druaux on 30/12/2022.
//

import UIKit

final class ViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet private var historyTextView: UITextView!
    @IBOutlet private var outputLabel: UILabel!
    @IBOutlet private var separatorButton: UIButton!
    @IBOutlet private var allClearButton: UIButton!
    @IBOutlet private var keysViewConstraint: NSLayoutConstraint!

    // MARK: - Properties

    private let dot = "."
    private let zero = "0"
    private lazy var decimalSeparator: String = dot
    private let calculator = Calculator()
    private let history = History()

    private var maxCharDefault: Int = 0
    private var maxChar: Int = 0

    private var selectedButton: UIButton?
    private var previousClickTime: Date?

    private var currentInputNumber: Double = 0.0

    private lazy var outputLabelCharSize = (zero as NSString).size(withAttributes: [.font: outputLabel.font!])
    private lazy var swipe: UISwipeGestureRecognizer = .init(target: self, action: #selector(self.swipeGesture(_:)))

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initOutputs()
        initMaxChar()
        initDecimalSeparator()

        /// Add a target to allClearButton to handle double click
        allClearButton.addTarget(self, action: #selector(allClearPressed), for: .touchUpInside)
    }

    /// Detect orientation changes and apply view modifications
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setCharPerLine()
    }

    /// Set max characters per line, based on screen orientation
    private func setCharPerLine() {
        if UIDevice.current.orientation.isLandscape {
            maxChar = 16
            keysViewConstraint.constant = view.safeAreaLayoutGuide.layoutFrame.height * 0.6
            scrollTextView()

            if currentInputNumber != 0.0 {
                outputLabel.text = currentInputNumber.displayAdjusted(maxChar)
            }
            historyTextView.textAlignment = .left
            historyTextView.textContainerInset = UIEdgeInsets(top: outputLabel.bounds.size.height, left: 0, bottom: 8, right: 0)
        } else {
            maxChar = maxCharDefault
            scrollTextView()

            if currentInputNumber != 0.0 {
                outputLabel.text = currentInputNumber.displayAdjusted(maxChar)
            }
            historyTextView.textAlignment = .right
            historyTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        }
    }

    /// Set swipe gesture to remove a digit from the number being entered
    @objc private func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        guard let mathExpressionElements = calculator.deleteNumber() else {
            return
        }
        updateViewFromExpression(mathExpressionElements)
    }

    // MARK: - Actions

    @IBAction private func allClearPressed(_ sender: UIButton) {
        calculator.allClear()
        outputLabel.text = zero
        currentInputNumber = 0.0
        deselectButton()
        scrollTextView()

        if let previousClickTime {
            let timeDiff = Date().timeIntervalSince(previousClickTime)
            if timeDiff < 0.5 {
                historyTextView.text = ""
                history.clear()
            }
        }
        previousClickTime = Date()
    }

    @IBAction private func plusMinusPressed(_ sender: UIButton) {
        let mathExpressionElements = calculator.getPlusMinus()
        updateViewFromExpression(mathExpressionElements)
    }

    @IBAction private func percentPressed(_ sender: UIButton) {
        let mathExpressionElements = calculator.getPercentage()
        updateViewFromExpression(mathExpressionElements)
    }

    @IBAction private func numberPressed(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else {
            return
        }
        deselectButton()
        let mathExpressionElements = calculator.prepareExpression(buttonText, maxChar)
        updateViewFromExpression(mathExpressionElements)
    }

    @IBAction private func operatorPressed(_ sender: UIButton) {
        guard let buttonText = sender.title(for: .normal) else {
            return
        }
        deselectButton()
        sender.isSelected = true
        selectedButton = sender

        let mathExpressionElements = calculator.prepareExpression(buttonText)
        updateViewFromExpression(mathExpressionElements)
    }

    @IBAction private func equalPressed(_ sender: UIButton) {
        deselectButton()
        let result = calculator.calculate()
        updateViewFromResult(result)
    }

    @IBAction private func separatorPressed(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else {
            return
        }
        deselectButton()
        let mathExpressionElements = calculator.prepareExpression(buttonText, maxChar)
        updateViewFromExpression(mathExpressionElements)
    }
}

// MARK: - View

private extension ViewController {
    func initOutputs() {
        historyTextView.text = ""
        outputLabel.text = zero

        /// Initialize outputLabel to dynamically change font size
        outputLabel.adjustsFontSizeToFitWidth = true
        outputLabel.minimumScaleFactor = 0.5

        /// Swipe Gesture of outputLabel
        swipe.direction = [.left, .right]
        outputLabel.addGestureRecognizer(swipe)
    }

    /// Get maximum number of characters per line in outputLabel (default value in portrait mode)
    func initMaxChar() {
        maxCharDefault = Int(outputLabel.bounds.width / outputLabelCharSize.width) + 1
        maxChar = maxCharDefault
    }

    func initDecimalSeparator() {
        let numberFormatter = NumberFormatter()
        decimalSeparator = numberFormatter.locale.decimalSeparator ?? dot
        separatorButton.setTitle(decimalSeparator, for: .normal)
    }

    func updateViewFromExpression(_ mathExpressionElements: [String]?) {
        if let mathElements = mathExpressionElements {
            guard let lastElement = mathExpressionElements?.last else {
                return
            }

            /// Update Current input number (for change from landscape mode to portrait mode)
            if lastElement.isNumber {
                currentInputNumber = Double(lastElement)!
            }

            updateHistoryView(from: mathElements)
            updateOutputLabel(from: lastElement)
        }
    }

    /// Update expression for history and historyTextView
    func updateHistoryView(from mathElements: [String]) {
        var expressionElements = [String]()
        for element in mathElements {
            if element.isArithmeticOperator {
                expressionElements.append(element.readableExpression)
            } else {
                if element.last == Character(dot) {
                    var tmpElement = element
                    tmpElement.removeLast()
                    if let newElement = Double(tmpElement)?.decimalNotation {
                        expressionElements.append(newElement + decimalSeparator)
                    }
                } else {
                    guard let number = Double(element) else {
                        return
                    }
                    if !element.isScientificNotation, element.count <= maxCharDefault, element.contains(dot), number.fraction == 0 {
                        let fractionDigits = element.split(separator: dot).last ?? ""
                        expressionElements.append(number.decimalNotation + decimalSeparator + fractionDigits)
                    } else {
                        expressionElements.append(number.displayAdjusted(10))
                    }
                }
            }
        }

        let expression = expressionElements.joined(separator: " ")
        history.updateHistory(expression)
        historyTextView.text = history.getHistory().joined(separator: "\n")
        scrollTextView()
    }

    /// Update current displayed number (outputLabel)
    func updateOutputLabel(from lastElement: String) {
        if lastElement.last == Character(dot) {
            var tmpElement = lastElement
            tmpElement.removeLast()
            if let newElement = Double(tmpElement)?.decimalNotation {
                outputLabel.text = newElement + decimalSeparator
            }
        } else if let lastNumber = Double(lastElement) {
            if !lastElement.isScientificNotation, lastElement.count <= maxChar, lastElement.contains(dot) {
                let fractionDigits = lastElement.split(separator: dot).last ?? ""
                guard let lastNumberInteger = lastNumber.decimalNotation.split(separator: decimalSeparator).first else {
                    return
                }
                outputLabel.text = lastNumberInteger + decimalSeparator + fractionDigits
            } else {
                outputLabel.text = lastNumber.displayAdjusted(maxChar)
            }
        }
    }

    func updateViewFromResult(_ result: Double?) {
        guard let resultNumber = result else { return }
        if resultNumber.isInfinite || resultNumber.isNaN {
            currentInputNumber = 0.0
            outputLabel.text = "Error"
        } else {
            currentInputNumber = resultNumber
            var records = history.getHistory()
            if let lastRecord = records.last {
                if lastRecord.last == Character(decimalSeparator) {
                    var newlastRecord = lastRecord
                    newlastRecord.removeLast()
                    records.removeLast()
                    records.append(newlastRecord)
                    history.updateHistory(newlastRecord)
                }
            }

            /// Add a new empty line to the history for next expression
            if let lastRecord = records.last, !lastRecord.isEmpty {
                history.addExpression("")
            }

            /// Update outputs
            historyTextView.text = records.joined(separator: "\n")
            outputLabel.text = currentInputNumber.displayAdjusted(maxChar)
        }
        scrollTextView()
    }

    func scrollTextView() {
        let range = NSRange(location: historyTextView.text.count - 1, length: 0)
        historyTextView.scrollRangeToVisible(range)
    }

    func deselectButton() {
        selectedButton?.isSelected = false
    }
}
