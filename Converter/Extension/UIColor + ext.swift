//
//  UIColor + ext.swift
//  Converter
//
//  Created by Victor Mashukevich on 12.11.24.
//

import Foundation
import UIKit

extension UIColor {
    // MARK: - core color
    static let primaryBackground = UIColor(hex: "#F2F2F2")
    static let primaryText = UIColor(hex: "#333333")
    static let secondaryText = UIColor(hex: "#666666")
    
    // MARK: - accent
    static let accentBlue = UIColor(hex: "#007AFF")
    static let accentGreen = UIColor(hex: "#34C759")

    // MARK: - input textField
    static let inputFieldBackground = UIColor(hex: "#F0F8FF")
    static let inputFieldBorder = UIColor(hex: "#CCCCCC")
    
    // MARK: - tableView
    static let tableBackground = UIColor(hex: "#FFFFFF")
    static let cellBackground = UIColor(hex: "#FAFAFA")
}

// MARK: - hex color
extension UIColor {
    convenience init(hex: String) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexFormatted = hexFormatted.replacingOccurrences(of: "#", with: "")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
