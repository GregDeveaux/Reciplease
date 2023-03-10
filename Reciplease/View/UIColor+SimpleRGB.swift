//
//  UIColor+SimpleRGB.swift
//  Reciplease
//
//  Created by Greg Deveaux on 29/12/2022.
//

import UIKit

extension UIColor {
    static func simpleRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }

        // color used in the app
    static let greenColor = UIColor.simpleRGB(red: 115, green: 246, blue: 119)
    static let darkBlue = UIColor.simpleRGB(red: 24, green: 29, blue: 50)
    static let darkGreen = UIColor.simpleRGB(red: 46, green: 70, blue: 65)
}
