//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Sylvain Druaux on 23/01/2023.
//

import XCTest
@testable import Calculator

class CalculatorTest: XCTestCase {
    var calc = Calculator()
    let maxChar = 10
    lazy var decimalSeparator: String = "."
        
    override func setUp() {
        super.setUp()
        let numberFormatter = NumberFormatter()
        decimalSeparator = numberFormatter.locale.decimalSeparator ?? "."
    }
    
    // MARK: - Separator tests
    // see CalculatorFirstTest
    
    // MARK: - Number tests
    // see CalculatorFirstTest
    
    // MARK: - Operand tests
    // see CalculatorFirstTest
    
    // MARK: - Delete number tests
    // see CalculatorFirstTest
    
    // MARK: - Calculate tests
    // see CalculatorSecondTest
    
    // MARK: - Percent tests
    // see CalculatorSecondTest
    
    // MARK: - PlusMinus tests
    // see CalculatorSecondTest
    
    // MARK: - Clear output tests
    // see CalculatorSecondTest
}
