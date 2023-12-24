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
        replacingOccurrences(of: ",", with: ".")
            .replacingOccurrences(of: "x", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
    }

    /// Convert calculator button text from math string to readable string.
    var readableExpression: String {
        replacingOccurrences(of: "*", with: "x")
            .replacingOccurrences(of: "/", with: "÷")
    }

    var isNumber: Bool {
        Double(self) != nil
    }

    var isArithmeticOperator: Bool {
        self == "+" || self == "-" || self == "*" || self == "/"
    }

    var isScientificNotation: Bool {
        contains("e")
    }

    var startWithMinus: Bool {
        hasPrefix("-")
    }
}
