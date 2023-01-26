//
//  String+Extension.swift
//  Calculator
//
//  Created by Sylvain Druaux on 01/01/2023.
//

import Foundation

extension String {
    
    /// Convert calculator button text from readable string to math string.
    /// - Returns: Example: "x" become "*"
    var mathExpression: String {
        return self
            .replacingOccurrences(of: ",", with: ".")
            .replacingOccurrences(of: "x", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
    }
    
    /// Convert calculator button text from math string to readable string.
    /// - Returns: Example: "*" become "x"
    var readableExpression: String {
        return self
            .replacingOccurrences(of: "*", with: "x")
            .replacingOccurrences(of: "/", with: "÷")
    }
    
    var isNumber: Bool {
        // let str = self.replacingOccurrences(of: ",", with: ".")
        return Double(self) != nil
    }
    
    var isArithmeticOperator: Bool {
        return self == "+" || self == "-" || self == "*" || self == "/"
    }
}
