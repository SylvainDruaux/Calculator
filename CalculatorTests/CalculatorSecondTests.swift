//
//  CalculatorSecondTests.swift
//  CalculatorTests
//
//  Created by Sylvain Druaux on 12/03/2023.
//

@testable import Calculator
import XCTest

final class CalculatorSecondTests: CalculatorTests {
    // MARK: - Calculate tests

    func testCalculateWithoutPreviousInput() {
        let result = calc.calculate()
        XCTAssertEqual(result, nil)
    }

    func testCalculateAfterOneOperand() {
        let num = calc.prepareExpression("3")
        let operand = calc.prepareExpression("+")
        let result = calc.calculate()
        XCTAssertEqual(num, ["3"])
        XCTAssertEqual(operand, ["3", "+"])
        XCTAssertEqual(result, nil)
    }

    func testCalculateAfterResultFromAddition() {
        let result1 = addition(with: calc, num1: "3", num2: "4")
        let result2 = calc.calculate()
        XCTAssertEqual(result1, 7)
        XCTAssertEqual(result2, 7)
    }

    func testCalculateAfterSeparator() {
        let num = calc.prepareExpression("6\(decimalSeparator)")
        let result = calc.calculate()
        XCTAssertEqual(num, ["6."])
        XCTAssertEqual(result, 6)
    }

    func testPriority() {
        let result = calcPriority(with: calc)
        XCTAssertEqual(result, -44.25)
    }

    func testVeryLargeNumber() {
        let result = calcVeryLongNumber(with: calc)
        XCTAssertEqual(result, 1e+27)
    }

    // MARK: - Percent tests

    func testPercentWithoutPreviousInput() {
        let result = calc.getPercentage()
        XCTAssertEqual(result, [])
    }

    func testPercentAfterNumber() {
        let num = calc.prepareExpression("26")
        let result = calc.getPercentage()
        XCTAssertEqual(num, ["26"])
        XCTAssertEqual(result, ["0.26"])
    }

    func testPercentAfterZero() {
        let num = calc.prepareExpression("0")
        let result = calc.getPercentage()
        XCTAssertEqual(num, ["0"])
        XCTAssertEqual(result, [])
    }

    func testPercentAfterResultFromAddition() {
        let result1 = addition(with: calc, num1: "7", num2: "5")
        let result2 = calc.getPercentage()
        XCTAssertEqual(result1, 12)
        XCTAssertEqual(result2, ["0.12"])
    }

    func testPercentAfterDivisionByZero() {
        let result1 = divisionByZero(with: calc, num1: "5", num2: "0")
        let result2 = calc.getPercentage()
        XCTAssert(result1!.isInfinite)
        XCTAssertEqual(result2, [])
    }

    // MARK: - PlusMinus tests

    func testPlusMinusWithoutPreviousInput() {
        let result = calc.getPlusMinus()
        XCTAssertEqual(result, ["-0"])
    }

    func testPlusMinusAfterPositiveNumber() {
        let num1 = calc.prepareExpression("50")
        let result = calc.getPlusMinus()
        XCTAssertEqual(num1, ["50"])
        XCTAssertEqual(result, ["-50"])
    }

    func testPlusMinusAfterNegativeNumber() {
        let num1 = calc.prepareExpression("-0\(decimalSeparator)25")
        let result = calc.getPlusMinus()
        XCTAssertEqual(num1, ["-0.25"])
        XCTAssertEqual(result, ["0.25"])
    }

    func testPlusMinusAfterOperand() {
        let num = calc.prepareExpression("7")
        let operand = calc.prepareExpression("+")
        let result = calc.getPlusMinus()
        XCTAssertEqual(num, ["7"])
        XCTAssertEqual(operand, ["7", "+"])
        XCTAssertEqual(result, ["7", "+", "-0"])
    }

    func testPlusMinusAfterResultFromAddition() {
        let result1 = addition(with: calc, num1: "7", num2: "-3")
        let result2 = calc.getPlusMinus()
        XCTAssertEqual(result1, 4)
        XCTAssertEqual(result2, ["-4"])
    }

    func testPlusMinusAfterResultWithDecimalDigit() {
        let result1 = addition(with: calc, num1: "7\(decimalSeparator)3", num2: "9")
        let result2 = calc.getPlusMinus()
        XCTAssertEqual(result1, 16.3)
        XCTAssertEqual(result2, ["-16.3"])
    }

    func testPlusMinusAfterDivisionByZero() {
        let result1 = divisionByZero(with: calc, num1: "8", num2: "0")
        let result2 = calc.getPlusMinus()
        XCTAssert(result1!.isInfinite)
        XCTAssertEqual(result2, [])
    }

    // MARK: - Clear output tests

    func testAllClear() {
        let result1 = addition(with: calc, num1: "10", num2: "5\(decimalSeparator)5")
        calc.allClear()
        let result2 = calc.prepareExpression(decimalSeparator)
        XCTAssertEqual(result1, 15.5)
        XCTAssertEqual(result2, ["0."])
    }
}
