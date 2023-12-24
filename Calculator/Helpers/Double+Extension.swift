//
//  Double+Extension.swift
//  Calculator
//
//  Created by Sylvain Druaux on 08/01/2023.
//

import Foundation

extension Double {
    var decimalNotation: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 100
        return numberFormatter.string(for: self) ?? String(self)
    }

    func scientificNotation(_ maxSignificantDigits: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .scientific
        numberFormatter.exponentSymbol = "e"
        numberFormatter.maximumSignificantDigits = maxSignificantDigits
        return numberFormatter.string(for: self) ?? String(self)
    }

    func displayAdjusted(_ maxCharacters: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        var maxFractionDigits = maxCharacters - 2
        let maxSignificantDigits = maxCharacters - 5

        /// When a double value is too long, it is in scientific notation
        guard !String(self).contains("e") else {
            return scientificNotation(maxSignificantDigits)
        }

        switch self {
        case _ where (wholeCount > maxCharacters && sign == .plus) || (wholeCount > maxCharacters + 1 && sign == .minus):
            /// Example: maxCharacters = 10, number = 4166666666667 > 4.16667e12
            return scientificNotation(maxSignificantDigits)
        case _ where (wholeCount == maxCharacters && sign == .plus) || (wholeCount == maxCharacters + 1 && sign == .minus):
            numberFormatter.maximumFractionDigits = 0
            return numberFormatter.string(for: self) ?? String(self)
        case _ where abs(whole) == 0 && fraction != 0:
            /// Number starts with -0. or 0. and also has fraction digits other than 0
            let factor = pow(10, maxFractionDigits)
            let num = self * (factor as NSDecimalNumber).doubleValue
            if num.whole == 0 {
                /// Example: maxCharacters = 10, number = 0.0000000052 > 5.2e-9
                return scientificNotation(maxSignificantDigits)
            } else {
                /// Example: maxCharacters = 10, number = 0.125555555555555 > 0.12555556
                numberFormatter.maximumFractionDigits = maxFractionDigits
                return numberFormatter.string(for: self) ?? String(self)
            }
        default:
            /// Example: maxCharacters = 10, number = 1025.0055555555 > 1025.00556
            maxFractionDigits = maxCharacters - wholeCount - 1
            numberFormatter.maximumFractionDigits = maxFractionDigits
        }
        return numberFormatter.string(for: self) ?? String(self)
    }

    var whole: Double {
        let double = trunc(self)
        return double
    }

    var fraction: Double {
        truncatingRemainder(dividingBy: 1)
    }

    var wholeCount: Int {
        String(whole).split(separator: ".").first!.count
    }

    var fractionVisible: String {
        let str = "\(self)"
        if str.contains(".") {
            return String(str.split(separator: ".").last!)
        }
        return ""
    }

    var fractionVisibleCount: Int {
        fractionVisible.count
    }
}
