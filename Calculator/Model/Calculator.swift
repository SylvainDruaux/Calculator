//
//  Calculator.swift
//  Calculator
//
//  Created by Sylvain Druaux on 31/12/2022.
//

import Foundation

final class Calculator {
    
    // MARK: - Properties
    private var mathExpressionElements = [String]()
    
    private var result: Double?
    
    // MARK: - Methods
    func prepareExpression(_ input: String, _ maxChar: Int = 10) -> [String] {
        let mathInput = input.mathExpression
        
        switch mathInput {
        case ".":
            return prepareFromSperator(mathInput)
                        
        case _ where mathInput.isNumber:
            return prepareFromNumber(mathInput, maxChar)
            
        case _ where mathInput.isArithmeticOperator:
            return prepareFromArithmeticOperator(mathInput)
            
        default:
            break
        }
        return mathExpressionElements
    }
    
    private func prepareFromSperator(_ mathInput: String) -> [String] {
        guard let lastElement = mathExpressionElements.last else {
            mathExpressionElements.append("0.")
            return mathExpressionElements
        }
        
        guard result == nil else {
            result = nil
            mathExpressionElements.removeAll()
            mathExpressionElements.append("0.")
            return mathExpressionElements
        }
        
        switch lastElement {
        case _ where lastElement.contains("."):
            return mathExpressionElements
        case _ where lastElement.isNumber && !lastElement.contains("."):
            let newLastElement = lastElement + mathInput
            mathExpressionElements.removeLast()
            mathExpressionElements.append(newLastElement)
        case _ where lastElement.isArithmeticOperator:
            mathExpressionElements.append("0.")
        default:
            break
        }
        return mathExpressionElements
    }
    
    private func prepareFromNumber(_ mathInput: String, _ maxChar: Int) -> [String] {
        guard let lastElement = mathExpressionElements.last else {
            mathExpressionElements.append(mathInput)
            return mathExpressionElements
        }
        
        guard result == nil else {
            result = nil
            mathExpressionElements.removeAll()
            mathExpressionElements.append(mathInput)
            return mathExpressionElements
        }
        
        guard lastElement.count < maxChar else {
            return mathExpressionElements
        }
        
        switch lastElement {
        case _ where lastElement == "0" || lastElement == "-0":
            var newLastElement = lastElement
            newLastElement.removeLast()
            mathExpressionElements.removeLast()
            mathExpressionElements.append(newLastElement + mathInput)
        case _ where lastElement.last == "." || lastElement.isNumber:
            let newLastElement = lastElement + mathInput
            mathExpressionElements.removeLast()
            mathExpressionElements.append(newLastElement)
        case _ where lastElement.isArithmeticOperator:
            mathExpressionElements.append(mathInput)
        default:
            break
        }
        return mathExpressionElements
    }
    
    private func prepareFromArithmeticOperator(_ mathInput: String) -> [String] {
        guard let lastElement = mathExpressionElements.last else {
            mathExpressionElements.append("0")
            mathExpressionElements.append(mathInput)
            return mathExpressionElements
        }
        
        if let result = self.result {
            if result.isInfinite || result.isNaN {
                mathExpressionElements.removeAll()
                mathExpressionElements.append("0")
                mathExpressionElements.append(mathInput)
            } else {
                mathExpressionElements.removeAll()
                let resultStr = String(result)
                if !resultStr.contains("e"), result.fraction == 0 {
                    let firstElement = String(resultStr.split(separator: ".").first!)
                    mathExpressionElements.append(firstElement)
                } else {
                    mathExpressionElements.append(resultStr)
                }
                mathExpressionElements.append(mathInput)
            }
            self.result = nil
            return mathExpressionElements
        }
        
        switch lastElement {
        case _ where lastElement.last == ".":
            var newLastElement = lastElement
            newLastElement.removeLast()
            mathExpressionElements.removeLast()
            mathExpressionElements.append(newLastElement)
            mathExpressionElements.append(mathInput)
        case _ where lastElement.isNumber:
            let lastElementDouble = Double(lastElement)
            if !lastElement.contains("e"), lastElementDouble?.fraction == 0 {
                let newLastElement = String(lastElement.split(separator: ".").first!)
                mathExpressionElements.removeLast()
                mathExpressionElements.append(newLastElement)
            }
            mathExpressionElements.append(mathInput)
        case _ where lastElement.isArithmeticOperator:
            mathExpressionElements.removeLast()
            mathExpressionElements.append(mathInput)
        default:
            break
        }
        return mathExpressionElements
    }
    
    func deleteNumber() -> [String]? {
        guard result == nil else {
            return nil
        }
        
        guard let lastElement = mathExpressionElements.last, lastElement.isNumber && !lastElement.contains("e") else {
            return mathExpressionElements
        }
        
        if lastElement.count > 1 {
            var newLastElement = lastElement
            if lastElement.count == 2 && lastElement.first == "-" {
                newLastElement.removeLast(2)
                mathExpressionElements.removeLast()
                newLastElement = "0"
            } else {
                newLastElement.removeLast()
                mathExpressionElements.removeLast()
            }
            mathExpressionElements.append(newLastElement)
        } else {
            mathExpressionElements.removeLast()
            mathExpressionElements.append("0")
        }
        return mathExpressionElements
    }
    
    func calculate() -> Double? {
        guard let lastElement = mathExpressionElements.last, !lastElement.isArithmeticOperator else {
            return nil
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
        guard let lastElement = mathExpressionElements.last, lastElement.isNumber else {
            return mathExpressionElements
        }
        
        var number: Double = 0
        
        if result != nil {
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
        
        guard number.fractionVisibleCount != 100, number != 0 else {
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
        
        if let result = self.result {
            if result.isInfinite || result.isNaN {
                mathExpressionElements.removeAll()
                self.result = nil
                return mathExpressionElements
            } else {
                mathExpressionElements.removeAll()
                let resultStr = String(result)
                if !resultStr.contains("e"), result.fraction == 0 {
                    let firstElement = String(resultStr.split(separator: ".").first!)
                    element = firstElement
                } else {
                    element = resultStr
                }
                self.result = nil
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
