//
//  History.swift
//  Calculator
//
//  Created by Sylvain Druaux on 17/01/2023.
//

import Foundation

// An idea for later
// https://stackoverflow.com/questions/29540105/preserve-order-of-dictionary-items-as-declared-in-swift
// struct History: Printable {
//    let expression: String
//    let result: String
//
//    // println() should print just the history expression:
//    var description: String { return expression }
// }
// let history = [
//    History(expression: "5 + 5", result: " = 10"),
// ]

// Get the expression and keep it after an operation has been performed (via the ViewController)
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
