//
//  NSExpression+Extension.swift
//  Calculator
//
//  Created by Sylvain Druaux on 14/01/2023.
//

import Foundation

extension NSExpression {
    func toFloatingPoint() -> NSExpression {
        switch expressionType {
        case .constantValue:
            if let value = constantValue as? NSNumber {
                return NSExpression(forConstantValue: NSNumber(value: value.doubleValue))
            }
        case .function:
            let newArgs = arguments.map { $0.map { $0.toFloatingPoint() } }
            return NSExpression(forFunction: operand, selectorName: function, arguments: newArgs)
        case .conditional:
            return NSExpression(forConditional: predicate, trueExpression: self.true.toFloatingPoint(), falseExpression: self.false.toFloatingPoint())
        case .unionSet:
            return NSExpression(forUnionSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .intersectSet:
            return NSExpression(forIntersectSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .minusSet:
            return NSExpression(forMinusSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .subquery:
            if let subQuery = collection as? NSExpression {
                return NSExpression(forSubquery: subQuery.toFloatingPoint(), usingIteratorVariable: variable, predicate: predicate)
            }
        case .aggregate:
            if let subExpressions = collection as? [NSExpression] {
                return NSExpression(forAggregate: subExpressions.map { $0.toFloatingPoint() })
            }
        case .evaluatedObject, .variable, .keyPath, .anyKey, .block:
            break
        default:
            break
        }
        return self
    }
}
