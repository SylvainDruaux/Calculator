//
//  CalculatorFirstTests.swift
//  CalculatorTests
//
//  Created by Sylvain Druaux on 12/03/2023.
//

@testable import Calculator
import XCTest

final class CalculatorFirstTests: CalculatorTests {
    // MARK: - Separator tests

    func testSeparatorWithoutPreviousInput() {
        let result = calc.prepareExpression(decimalSeparator)
        XCTAssertEqual(result, ["0."])
    }

    func testSeparatorAfterNumber() {
        let num = calc.prepareExpression("5")
        let result = calc.prepareExpression(decimalSeparator)
        XCTAssertEqual(num, ["5"])
        XCTAssertEqual(result, ["5."])
    }

    func testSeparatorAfterOperator() {
        let num = calc.prepareExpression("9")
        let operand = calc.prepareExpression("+")
        let result = calc.prepareExpression(decimalSeparator)
        XCTAssertEqual(num, ["9"])
        XCTAssertEqual(operand, ["9", "+"])
        XCTAssertEqual(result, ["9", "+", "0."])
    }

    func testSeparatorWithNumberEndingBySeparator() {
        let num = calc.prepareExpression("8\(decimalSeparator)")
        let result = calc.prepareExpression(decimalSeparator)
        XCTAssertEqual(num, ["8."])
        XCTAssertEqual(result, ["8."])
    }

    func testSeparatorAfterResultFromAddition() {
        let result1 = addition(with: calc, num1: "2", num2: "9")
        let result2 = calc.prepareExpression(decimalSeparator)
        XCTAssertEqual(result1, 11)
        XCTAssertEqual(result2, ["0."])
    }

    // MARK: - Number tests

    func testNumberAfterNumber() {
        let num1 = calc.prepareExpression("1")
        let num2 = calc.prepareExpression("2")
        XCTAssertEqual(num1, ["1"])
        XCTAssertEqual(num2, ["12"])
    }

    func testNumberLargerThanMaxChar() {
        let num1 = calc.prepareExpression("1000000000")
        let num2 = calc.prepareExpression("0")
        XCTAssertEqual(num1, ["1000000000"])
        XCTAssertEqual(num2, ["1000000000"])
    }

    func testNumberAfterZero() {
        let num1 = calc.prepareExpression("0")
        let num2 = calc.prepareExpression("4")
        XCTAssertEqual(num1, ["0"])
        XCTAssertEqual(num2, ["4"])
    }

    func testNumberAfterZeroOrMinusZero() {
        let num1 = calc.prepareExpression("0")
        let sign = calc.getPlusMinus()
        let num2 = calc.prepareExpression("4")
        XCTAssertEqual(num1, ["0"])
        XCTAssertEqual(sign, ["-0"])
        XCTAssertEqual(num2, ["-4"])
    }

    func testNumberAfterResultFromAddition() {
        let result1 = addition(with: calc, num1: "2", num2: "6")
        let result2 = calc.prepareExpression("3")
        XCTAssertEqual(result1, 8)
        XCTAssertEqual(result2, ["3"])
    }

    // MARK: - Operand tests

    func testOperandWithoutPreviousInput() {
        let result = calc.prepareExpression("x")
        XCTAssertEqual(result, ["0", "*"])
    }

    func testOperandAfterResultFromAddition() {
        let result1 = addition(with: calc, num1: "3", num2: "4")
        let result2 = calc.prepareExpression("÷")
        XCTAssertEqual(result1, 7)
        XCTAssertEqual(result2, ["7", "/"])
    }

    func testOperandAfterDivisionByZero() {
        let result1 = divisionByZero(with: calc, num1: "5", num2: "0")
        let result2 = calc.prepareExpression("+")
        XCTAssert(result1!.isInfinite)
        XCTAssertEqual(result2, ["0", "+"])
    }

    func testOperandAfterResultWithDecimalDigit() {
        let result1 = addition(with: calc, num1: "3\(decimalSeparator)6", num2: "4")
        let result2 = calc.prepareExpression("÷")
        XCTAssertEqual(result1, 7.6)
        XCTAssertEqual(result2, ["7.6", "/"])
    }

    func testOperandAfterSeparator() {
        let num = calc.prepareExpression("3\(decimalSeparator)")
        let result = calc.prepareExpression("÷")
        XCTAssertEqual(num, ["3."])
        XCTAssertEqual(result, ["3", "/"])
    }

    func testOperandAfterOperand() {
        let num = calc.prepareExpression("3")
        let operand = calc.prepareExpression("+")
        let result = calc.prepareExpression("÷")
        XCTAssertEqual(num, ["3"])
        XCTAssertEqual(operand, ["3", "+"])
        XCTAssertEqual(result, ["3", "/"])
    }

    // MARK: - Delete number tests

    func testDeleteNumberWithoutPreviousInput() {
        let result = calc.deleteNumber()
        XCTAssertEqual(result, [])
    }

    func testDeleteNumberAfterNumberInput() {
        let num = calc.prepareExpression("125")
        let result = calc.deleteNumber()
        XCTAssertEqual(num, ["125"])
        XCTAssertEqual(result, ["12"])
    }

    func testDeleteNumberAfterOneLastDigit() {
        let num = calc.prepareExpression("1")
        let result = calc.deleteNumber()
        XCTAssertEqual(num, ["1"])
        XCTAssertEqual(result, ["0"])
    }

    func testDeleteNumberAfterOneLastNegativeDigit() {
        let num = calc.prepareExpression("-1")
        let result = calc.deleteNumber()
        XCTAssertEqual(num, ["-1"])
        XCTAssertEqual(result, ["0"])
    }

    func testDeleteNumberAfterResultFromAddition() {
        let result1 = addition(with: calc, num1: "5", num2: "4")
        let result2 = calc.deleteNumber()
        XCTAssertEqual(result1, 9)
        XCTAssertEqual(result2, nil)
    }
}
