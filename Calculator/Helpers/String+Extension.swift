//
//  String+Extension.swift
//  Calculator
//
//  Created by Sylvain Druaux on 01/01/2023.
//

import Foundation

extension String {
    
    /// Convert calculator button text from readable string to math string.
    var mathExpression: String {
        return self
            .replacingOccurrences(of: ",", with: ".")
            .replacingOccurrences(of: "x", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
    }
    
    /// Convert calculator button text from math string to readable string.
    var readableExpression: String {
        return self
            .replacingOccurrences(of: "*", with: "x")
            .replacingOccurrences(of: "/", with: "÷")
    }
    
    var isNumber: Bool {
        return Double(self) != nil
    }
    
    var isArithmeticOperator: Bool {
        return self == "+" || self == "-" || self == "*" || self == "/"
    }
    
    var isScientificNotation: Bool {
        return self.contains("e")
    }
    
    var startWithMinus: Bool {
        return self.hasPrefix("-")
    }
}
