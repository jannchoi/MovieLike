//
//  UIButton+.swift
//  MovieLike
//
//  Created by 최정안 on 1/27/25.
//

import UIKit
extension UIButton {
    func setButtonTitle(title: String, color: CGColor, size: CGFloat, weight: UIFont.Weight = .regular) {
        let att = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor : color, .font : UIFont.systemFont(ofSize: size, weight: weight)])
        self.setAttributedTitle(att, for: .normal)
    }
}
