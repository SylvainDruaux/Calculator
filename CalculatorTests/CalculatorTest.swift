//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Cobra on 23/01/2023.
//

import XCTest
@testable import Calculator

final class CalculatorTest: XCTestCase {
    var calc: Calculator!
    
    private lazy var decimalSeparator: String = "."
        
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        // Setting the separator var ("." or "," based on locale)
        let numberFormatter = NumberFormatter()
        decimalSeparator = numberFormatter.locale.decimalSeparator ?? "."
        calc = Calculator()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }

    func testAddition() throws {
        let num1 = calc.prepareExpression("5")
        let operand = calc.prepareExpression("+")
        let num2 = calc.prepareExpression("5")
        let result = calc.calculate()
        
        XCTAssertEqual(num1, ["5"])
        XCTAssertEqual(operand, ["5", "+"])
        XCTAssertEqual(num2, ["5", "+", "5"])
        XCTAssertEqual(result, 10)
    }
    
    func testSubstraction() throws {
        let num1 = calc.prepareExpression("10")
        let operand = calc.prepareExpression("-")
        let num2 = calc.prepareExpression("5.6")
        let result = calc.calculate()
        
        XCTAssertEqual(num1, ["10"])
        XCTAssertEqual(operand, ["10", "-"])
        XCTAssertEqual(num2, ["10", "-", "5.6"])
        XCTAssertEqual(result, 4.4)
    }
    
    func testMultiplication() throws {
        let num1 = calc.prepareExpression("9.5")
        let operand = calc.prepareExpression("x")
        let num2 = calc.prepareExpression("8")
        let result = calc.calculate()
        
        XCTAssertEqual(num1, ["9.5"])
        XCTAssertEqual(operand, ["9.5", "*"])
        XCTAssertEqual(num2, ["9.5", "*", "8"])
        XCTAssertEqual(result, 76)
    }
    
    func testDivision() throws {
        let num1 = calc.prepareExpression("96")
        let operand = calc.prepareExpression("÷")
        let num2 = calc.prepareExpression("5")
        let result = calc.calculate()
        
        XCTAssertEqual(num1, ["96"])
        XCTAssertEqual(operand, ["96", "/"])
        XCTAssertEqual(num2, ["96", "/", "5"])
        XCTAssertEqual(result, 19.2)
    }
    
    func testPriority() throws {
        let num1 = calc.prepareExpression("5")
        let operand1 = calc.prepareExpression("+")
        let num2 = calc.prepareExpression("6")
        let operand2 = calc.prepareExpression("÷")
        let num3 = calc.prepareExpression("8")
        let operand3 = calc.prepareExpression("-")
        let num4 = calc.prepareExpression("10")
        let operand4 = calc.prepareExpression("*")
        let num5 = calc.prepareExpression("5")
        let result = calc.calculate()
        
        XCTAssertEqual(num1, ["5"])
        XCTAssertEqual(operand1, ["5", "+"])
        XCTAssertEqual(num2, ["5", "+", "6"])
        XCTAssertEqual(operand2, ["5", "+", "6", "/"])
        XCTAssertEqual(num3, ["5", "+", "6", "/", "8"])
        XCTAssertEqual(operand3, ["5", "+", "6", "/", "8", "-"])
        XCTAssertEqual(num4, ["5", "+", "6", "/", "8", "-", "10"])
        XCTAssertEqual(operand4, ["5", "+", "6", "/", "8", "-", "10", "*"])
        XCTAssertEqual(num5, ["5", "+", "6", "/", "8", "-", "10", "*", "5"])
        XCTAssertEqual(result, -44.25)
    }
    
    func testPercent() throws {
        let num1 = calc.prepareExpression("26")
        let result = calc.getPercentage()
        
        XCTAssertEqual(num1, ["26"])
        XCTAssertEqual(result, ["0.26"])
    }
    
    func testPlusMinus() throws {
        let num1 = calc.prepareExpression("50")
        let result = calc.getPlusMinus()
        
        XCTAssertEqual(num1, ["50"])
        XCTAssertEqual(result, ["-50"])
    }
    
    func testMinusPlus() throws {
        let num1 = calc.prepareExpression("-0\(decimalSeparator)25")
        let result = calc.getPlusMinus()
        
        XCTAssertEqual(num1, ["-0.25"])
        XCTAssertEqual(result, ["0.25"])
    }
    
    func testSeparator() throws {
        let num = calc.prepareExpression("\(decimalSeparator)")
        XCTAssertEqual(num, ["0."])
    }
}
