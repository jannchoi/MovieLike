//
//  UIColor+.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit

func hexColor(hex: String) -> UIColor {
    let int = Int(hex, radix: 16)!
    
    let red = CGFloat((int >> 16) & 0xFF) / 255.0
    let green = CGFloat((int >> 8) & 0xFF) / 255.0
    let blue = CGFloat(int & 0xFF) / 255.0
    
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
}

// UIColor 확장
extension UIColor {
    static let MyBlue = hexColor(hex: "0099D6")
    static let MylightGray = hexColor(hex: "E1E1E1")
    static let MyGray = hexColor(hex: "8E8E8E")
    static let Myblack = hexColor(hex: "000000")
    static let Mywhite = hexColor(hex: "FFFFFF")
}
