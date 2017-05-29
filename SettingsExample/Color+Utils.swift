//
//  Color+Utils.swift
//  SettingsExample
//
//  Created by Miwand Najafe on 2017-05-28.
//  Copyright © 2017 Miwand Najafe. All rights reserved.
//

import UIKit

extension UIColor {
    
    // Light Colour scheme
    static let customGreen = UIColor.getColorWith(hex: "#75a557")
    static let customYellow = UIColor.getColorWith(hex: "#ffea73")
    static let customTeal = UIColor.getColorWith(hex: "#8be9fd")
    static let customOrange = UIColor.getColorWith(hex: "#faa009")
    
    // Dark Colour scheme
    static let customDGreen = UIColor.getColorWith(hex: "#008080")
    static let customBrown = UIColor.getColorWith(hex: "#794044")
    static let customBlack = UIColor.getColorWith(hex: "#131212")
    static let customPurple = UIColor.getColorWith(hex: "#5c1160")
    
    
    class func getColorWith (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
