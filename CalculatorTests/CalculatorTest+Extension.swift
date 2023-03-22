//
//  CalculatorTest+Extension.swift
//  CalculatorTests
//
//  Created by Sylvain Druaux on 11/03/2023.
//

import Foundation
@testable import Calculator

extension CalculatorTest {
    func addition(with calc: Calculator, num1: String, num2: String) -> Double? {
        var _ = calc.prepareExpression(num1)
        _ = calc.prepareExpression("+")
        _ = calc.prepareExpression(num2)
        let result = calc.calculate()
        return result
    }
    
    func divisionByZero(with calc: Calculator, num1: String, num2: String) -> Double? {
        var _ = calc.prepareExpression(num1)
        _ = calc.prepareExpression("÷")
        _ = calc.prepareExpression(num2)
        let result = calc.calculate()
        return result
    }
    
    func calcPriority(with calc: Calculator) -> Double? {
        var _ = calc.prepareExpression("5\(decimalSeparator)0")
        _ = calc.prepareExpression("+")
        _ = calc.prepareExpression("6")
        _ = calc.prepareExpression("÷")
        _ = calc.prepareExpression("8\(decimalSeparator)0")
        _ = calc.prepareExpression("-")
        _ = calc.prepareExpression("10\(decimalSeparator)0")
        _ = calc.prepareExpression("*")
        _ = calc.prepareExpression("5")
        let result = calc.calculate()
        return result
    }
    
    func calcVeryLongNumber(with calc: Calculator) -> Double? {
        var _ = calc.prepareExpression("1000000000")
        _ = calc.prepareExpression("x")
        _ = calc.prepareExpression("1000000000")
        _ = calc.prepareExpression("x")
        _ = calc.prepareExpression("1000000000")
        let result = calc.calculate()
        return result
    }
}
