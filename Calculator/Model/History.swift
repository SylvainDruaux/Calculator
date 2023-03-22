//
//  History.swift
//  Calculator
//
//  Created by Sylvain Druaux on 17/01/2023.
//

import Foundation

final class History {
    private var expressionHistory = [String]()
    
    func addExpression(_ expression: String ) {
        expressionHistory.append(expression)
    }
    
    func updateHistory(_ expression: String) {
        if expressionHistory.isEmpty {
            addExpression(expression)
        } else {
            expressionHistory.removeLast()
            addExpression(expression)
        }
    }
    
    func getHistory() -> [String] {
        return expressionHistory
    }
    
    func clear() {
        expressionHistory.removeAll()
    }
}
