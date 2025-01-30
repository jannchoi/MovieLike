//
//  UIButton+.swift
//  MovieLike
//
//  Created by 최정안 on 1/27/25.
//

import UIKit
extension UIButton {
    func setButtonTitle(title: String, color: UIColor, size: CGFloat, weight: UIFont.Weight = .regular) {
        let att = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor : color, .font : UIFont.systemFont(ofSize: size, weight: weight)])
        self.setAttributedTitle(att, for: .normal)
    }
    
    func setHeartButton() {
        if UserDefaultsManager.shared.like.contains(self.tag) {
            self.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            self.setImage(UIImage(systemName: "heart"), for: .normal)
        }

    }
    func addTargetToHeartButton() {
        self.addTarget(self, action: #selector(heartButtonTapped3), for: .touchUpInside)
    }
    @objc func heartButtonTapped3(_ sender: UIButton) {
        if let idx = UserDefaultsManager.shared.like.firstIndex(of: sender.tag) {
            UserDefaultsManager.shared.like.remove(at: idx)
            self.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            UserDefaultsManager.shared.like.append(sender.tag)
            self.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    
}
