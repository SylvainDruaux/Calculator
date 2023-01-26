//
//  Calculator.swift
//  Calculator
//
//  Created by Sylvain Druaux on 31/12/2022.
//

import Foundation

final class Calculator {
    
    // MARK: - Properties
    // Expression in mathematical format, separated by elements
    private var mathExpressionElements = [String]()
    
    private var result: Double?
    
    // MARK: - Methods
    func prepareExpression(_ input: String, _ maxChar: Int = 10) -> [String] {
        let mathInput = input.mathExpression
        
        switch mathInput {
        case ".": // If mathInput is a separator
            guard let lastElement = mathExpressionElements.last else { // If expression is empty
                mathExpressionElements.append("0.")
                return mathExpressionElements
            }
            
            guard result == nil else { // If previous result, 0. replaces the previous result
                result = nil
                mathExpressionElements.removeAll()
                mathExpressionElements.append("0.")
                return mathExpressionElements
            }
            
            switch lastElement {
            case _ where lastElement.contains("."): // If lastElement contains (or ends with) a separator
                return mathExpressionElements
            case _ where lastElement.isNumber && !lastElement.contains("."): // If lastElement is a number without any separator
                let newLastElement = lastElement + mathInput
                mathExpressionElements.removeLast()
                mathExpressionElements.append(newLastElement)
            case _ where lastElement.isArithmeticOperator: // If lastElement is an operand
                mathExpressionElements.append("0.")
            default:
                break
            }
            
        case _ where mathInput.isNumber: // If mathInput is a number
            guard let lastElement = mathExpressionElements.last else { // If expression is empty
                mathExpressionElements.append(mathInput)
                return mathExpressionElements
            }
            
            guard result == nil else { // If previous result, a new number replaces the previous result
                result = nil
                mathExpressionElements.removeAll()
                mathExpressionElements.append(mathInput)
                return mathExpressionElements
            }
            
            guard lastElement.count < maxChar else { // If lastElement = maxChar, no change
                return mathExpressionElements
            }
            
            switch lastElement {
            case _ where lastElement == "-0": // If lastElement is -0
                var newLastElement = lastElement
                newLastElement.removeLast()
                mathExpressionElements.removeLast()
                mathExpressionElements.append(newLastElement + mathInput)
            case _ where lastElement.last == "." || lastElement.isNumber: // If lastElement is a number with or without a separator
                let newLastElement = lastElement + mathInput
                mathExpressionElements.removeLast()
                mathExpressionElements.append(newLastElement)
            case _ where lastElement.isArithmeticOperator: // If lastElement is an operand
                mathExpressionElements.append(mathInput)
            default:
                break
            }
            
        case _ where mathInput.isArithmeticOperator: // If mathInput is an operand
            guard let lastElement = mathExpressionElements.last else { // If expression is empty
                mathExpressionElements.append("0")
                mathExpressionElements.append(mathInput)
                return mathExpressionElements
            }
            
            guard result == nil else { // If previous result, the previous result replaces the whole expression (except if is an infinite number)
                if result!.isInfinite || result!.isNaN {
                    mathExpressionElements.removeAll()
                    mathExpressionElements.append("0")
                    mathExpressionElements.append(mathInput)
                } else {
                    mathExpressionElements.removeAll()
                    mathExpressionElements.append("\(result!)")
                    mathExpressionElements.append(mathInput)
                }
                result = nil
                return mathExpressionElements
            }
            
            switch lastElement {
            case _ where lastElement.last == ".": // If lastElement ends with a separator
                var newLastElement = lastElement
                newLastElement.removeLast()
                mathExpressionElements.removeLast()
                mathExpressionElements.append(newLastElement)
                mathExpressionElements.append(mathInput)
            case _ where lastElement.isNumber: // If lastElement is a number (not ending by a separator)
                let lastElementDouble = Double(lastElement)
                if lastElementDouble?.fraction == 0 {
                    let newLastElement = String(lastElement.split(separator: ".").first!)
                    mathExpressionElements.removeLast()
                    mathExpressionElements.append(newLastElement)
                }
                mathExpressionElements.append(mathInput)
            case _ where lastElement.isArithmeticOperator: // If lastElement is an operand
                mathExpressionElements.removeLast()
                mathExpressionElements.append(mathInput)
            default:
                break
            }
            
        default:
            break
        }
        return mathExpressionElements
    }
    
    func deleteNumber() -> [String] {
        guard result == nil else { // If previous result, no change
            return mathExpressionElements
        }
        
        guard let lastElement = mathExpressionElements.last else {
            return mathExpressionElements
        }
        
        if lastElement.isNumber && !lastElement.contains("e") {
            if lastElement.count > 1 {
                var newLastElement = lastElement
                newLastElement.removeLast()
                mathExpressionElements.removeLast()
                mathExpressionElements.append(newLastElement)
            } else {
                mathExpressionElements.removeLast()
                mathExpressionElements.append("0")
            }
        }
        return mathExpressionElements
    }
    
    func calculate() -> Double? {
        guard let lastElement = mathExpressionElements.last else {
            return nil
        }
        
        if let previousResult = result {
            if mathExpressionElements.count == 1 && lastElement.isNumber && Double(lastElement) == previousResult {
                return previousResult
            }
        }
        
        // Checking if expression ends with arithmetic operator
        if lastElement.isArithmeticOperator {
            // Keep first part of the expression (without the last operator)
            var elementsFirstPart = mathExpressionElements
            elementsFirstPart.removeLast()
            
            let expressionOne = elementsFirstPart.joined(separator: " ")
            
            // Calculating the first part of the expression
            let operationOne = NSExpression(format: expressionOne)
            guard let mathValue = operationOne.toFloatingPoint().expressionValue(with: nil, context: nil) as? Double else {
                return nil
            }
            
            // Calculating result of first part with the last operator
            // Example: if result of first part is 5 and operator is *, then new expression will be 5 * 5
            let newExpression = "\(mathValue) \(lastElement) \(mathValue)"
            let operation = NSExpression(format: newExpression)
            guard let mathValue = operation.toFloatingPoint().expressionValue(with: nil, context: nil) as? Double else {
                return nil
            }
            result = mathValue
            return result
        }
        
        if lastElement.last == "." {
            var newLastElement = lastElement
            newLastElement.removeLast()
            mathExpressionElements.removeLast()
            mathExpressionElements.append(newLastElement)
        }
        
        let mathExpression = mathExpressionElements.joined(separator: " ")
        let operation = NSExpression(format: mathExpression)
        guard let mathValue = operation.toFloatingPoint().expressionValue(with: nil, context: nil) as? Double else {
            return nil
        }
        result = mathValue
        return result
    }
    
    func getPercentage() -> [String] {
        guard let lastElement = mathExpressionElements.last else {
            return mathExpressionElements
        }
        
        if !lastElement.isNumber {
            return mathExpressionElements
        }
        
        var number: Double = 0
        
        if result != nil { // If previous result, uses the previous result (except if is an infinite number)
            if result!.isInfinite || result!.isNaN {
                mathExpressionElements.removeAll()
                result = nil
                return mathExpressionElements
            } else {
                number = result!
                mathExpressionElements.removeAll()
                result = nil
            }
        } else {
            number = Double(lastElement)!
            mathExpressionElements.removeLast()
        }
        
        if number.fractionVisibleCount == 100 {
            return mathExpressionElements
        }
        let lastNumberPercentage = number / 100
        mathExpressionElements.append("\(lastNumberPercentage)")
        return mathExpressionElements
    }
    
    func getPlusMinus() -> [String] {
        guard let lastElement = mathExpressionElements.last else {
            mathExpressionElements.append("-0")
            return mathExpressionElements
        }
        
        if lastElement.isArithmeticOperator {
            mathExpressionElements.append("-0")
            return mathExpressionElements
        }
        
        var element: String = ""
        
        if result != nil { // If previous result, uses the previous result (except if is an infinite number)
            if result!.isInfinite || result!.isNaN {
                mathExpressionElements.removeAll()
                result = nil
                return mathExpressionElements
            } else {
                element = "\(result!)"
                mathExpressionElements.removeAll()
                result = nil
            }
        } else {
            element = lastElement
            mathExpressionElements.removeLast()
        }
        
        if element.hasPrefix("-") {
            var firstRemoved = element
            firstRemoved.removeFirst()
            mathExpressionElements.append(firstRemoved)
        } else {
            var firstAdded = element
            firstAdded = "-" + element
            mathExpressionElements.append(firstAdded)
        }
        return mathExpressionElements
    }
    
    func allClear() {
        mathExpressionElements.removeAll()
        result = nil
    }
}
