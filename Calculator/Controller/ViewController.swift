//
//  ViewController.swift
//  Calculator
//
//  Created by Sylvain Druaux on 30/12/2022.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private var outputTextView: UITextView!
    @IBOutlet private var outputLabel: UILabel!
    @IBOutlet private var separatorButton: UIButton!
    @IBOutlet var allClearButton: UIButton!
    
    // MARK: - Properties
    private lazy var decimalSeparator: String = "."
    private let calculator = Calculator()
    private let history = History()
    
    private var maxCharDefault: Int = 0
    private var maxChar: Int = 0
    
    private var selectedButton: UIButton?
    private var previousClickTime: Date?
    
    private var currentInputNumber: Double = 0
    
    private lazy var outputLabelCharSize = ("0" as NSString).size(withAttributes: [.font: outputLabel.font!])
    private lazy var swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture(_:)))
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize outputs
        outputTextView.text = ""
        outputLabel.text = "0"
        
        // Get maximum number of characters per line in outputLabel (default value in portrait mode)
        maxCharDefault = Int(outputLabel.bounds.width / outputLabelCharSize.width) + 1
        
        // Initialize maximum number of characters per line in outputLabel
        maxChar = maxCharDefault
        
        // Initialize outputLabel to dynamically change font size
        outputLabel.adjustsFontSizeToFitWidth = true
        outputLabel.minimumScaleFactor = 0.5
        
        // Setting the separator var ("." or "," based on locale)
        let numberFormatter = NumberFormatter()
        decimalSeparator = numberFormatter.locale.decimalSeparator ?? "."
        
        // Setting the text of the separator button ("." or "," based on locale)
        separatorButton.setTitle(decimalSeparator, for: .normal)
        // calculator.separator = separator
        
        // Swipe Gesture of outputLabel
        // https://developer.apple.com/documentation/uikit/uiswipegesturerecognizer
        // https://riptutorial.com/ios/example/12954/uiswipegesturerecognizer
        swipe.direction = [.left, .right]
        outputLabel.addGestureRecognizer(swipe)
        
        // Add a target to allClearButton to handle double click
        allClearButton.addTarget(self, action: #selector(allClearPressed), for: .touchUpInside)
    }
    
    /// Detect orientation changes and apply view modifications
    /// https://stackoverflow.com/questions/38894031/swift-how-to-detect-orientation-changes
    /// https://developer.apple.com/documentation/uikit/uicontentcontainer/1621466-viewwilltransition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setCharPerLine()
    }
    
    /// Set max characters per line, based on screen orientation
    /// https://stackoverflow.com/questions/13836578/how-to-get-current-orientation-of-device-programmatically-in-ios-6
    private func setCharPerLine() {
        if UIDevice.current.orientation.isLandscape {
            // Landscape mode
            maxChar = 17 // (18 with minus sign)
            scrollTextView()
            if currentInputNumber != 0 {
                outputLabel.text = currentInputNumber.displayAdjusted(maxChar)
            }
            outputTextView.textAlignment = .left
            outputTextView.textContainerInset = UIEdgeInsets(top: outputLabel.bounds.size.height, left: 0, bottom: 8, right: 0)
        } else {
            // Portrait mode
            maxChar = maxCharDefault
            scrollTextView()
            if currentInputNumber != 0 { // Other than 0,0000000000
                outputLabel.text = currentInputNumber.displayAdjusted(maxChar)
            } else if outputLabel.text?.count ?? 0 > maxChar {
                outputLabel.text = String(outputLabel.text!.prefix(maxChar))
            }
            outputTextView.textAlignment = .right
            outputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        }
    }
    
    /// Set swipe gesture to remove a digit from the number being entered
    @objc private func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        let mathExpressionElements = calculator.deleteNumber()
        updateViewFromExpression(mathExpressionElements)
    }
    
    private func scrollTextView() {
        let range = NSRange(location: outputTextView.text.count - 1, length: 0)
        outputTextView.scrollRangeToVisible(range)
    }
    
    private func deselectButton() {
        if let selected = selectedButton {
            selected.isSelected = false
        }
    }
    
    private func updateViewFromExpression(_ mathExpressionElements: [String]?) {
        if let mathElements = mathExpressionElements {
            guard let lastNumber = mathExpressionElements?.last else {
                return
            }
            
            // Update expression for history and outputTextView
            var expressionElements = [String]()
            for element in mathElements {
                if element.isArithmeticOperator {
                    expressionElements.append(element.readableExpression)
                } else { // Numbers
                    if element.last == "." {
                        var tmpElement = element
                        tmpElement.removeLast()
                        if let newElement = Double(tmpElement)?.decimalNotation {
                            expressionElements.append(newElement + decimalSeparator)
                        }
                    } else {
                        guard let elementDouble = Double(element) else {
                            return
                        }
                        if element.count <= maxCharDefault && element.contains(".") && elementDouble.fraction == 0 {
                            let fractionDigits = element.split(separator: ".").last ?? ""
                            expressionElements.append(elementDouble.decimalNotation + decimalSeparator + fractionDigits)
                        } else {
                            expressionElements.append(elementDouble.displayAdjusted(10))
                        }
                    }
                }
            }
            
            let expression = expressionElements.joined(separator: " ")
            history.updateHistory(expression)
            outputTextView.text = history.getHistory().joined(separator: "\n")
            
            // Update current displayed number (outputLabel)
            if lastNumber.last == "." {
                var tmpElement = lastNumber
                tmpElement.removeLast()
                if let newElement = Double(tmpElement)?.decimalNotation {
                    outputLabel.text = newElement + decimalSeparator
                }
            } else {
                guard let lastNumberDouble = Double(lastNumber) else {
                    return
                }
                if lastNumber.count <= maxChar && lastNumber.contains(".") && lastNumberDouble.fraction == 0 {
                    let fractionDigits = lastNumber.split(separator: ".").last ?? ""
                    outputLabel.text = lastNumberDouble.decimalNotation + decimalSeparator + fractionDigits
                } else {
                    currentInputNumber = lastNumberDouble
                    outputLabel.text = currentInputNumber.displayAdjusted(maxChar)
                }
            }
            scrollTextView()
        }
    }
    
    private func updateViewFromResult(_ result: Double?) {
        if let resultNumber = result {
            if resultNumber.isInfinite || resultNumber.isNaN {
                currentInputNumber = 0
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
                
                // Add a new empty line to the history for next expression
                if records.last != "" {
                    history.addExpression("")
                }
                
                // Update TextView
                outputTextView.text = records.joined(separator: "\n")
                
                // Update Label
                outputLabel.text = currentInputNumber.displayAdjusted(maxChar)
            }
            scrollTextView()
        }
    }
    
    // MARK: - Actions
    @IBAction private func allClearPressed(_ sender: UIButton) {
        calculator.allClear()
        outputLabel.text = "0"
        currentInputNumber = 0
        deselectButton()
        scrollTextView()
        
        if let previousClickTime = previousClickTime {
            let timeDiff = Date().timeIntervalSince(previousClickTime)
            if timeDiff < 0.5 {
                outputTextView.text = ""
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
            return }
        // Deselect operator button if selected
        deselectButton()
        
        let mathExpressionElements = calculator.prepareExpression(buttonText, maxChar)
        updateViewFromExpression(mathExpressionElements)
    }
    
    @IBAction private func operatorPressed(_ sender: UIButton) {
        guard let buttonText = sender.title(for: .normal) else {
            return }
        deselectButton()
        sender.isSelected = true
        selectedButton = sender
        
        let mathExpressionElements = calculator.prepareExpression(buttonText)
        updateViewFromExpression(mathExpressionElements)
    }
    
    @IBAction private func equalPressed(_ sender: UIButton) {
        // Deselect operator button if selected
        deselectButton()
        
        // Get result
        let result = calculator.calculate()
        updateViewFromResult(result)
    }
    
    @IBAction private func separatorPressed(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else {
            return }
        // Deselect operator button if selected
        deselectButton()

        let mathExpressionElements = calculator.prepareExpression(buttonText, maxChar)
        updateViewFromExpression(mathExpressionElements)
    }
}
