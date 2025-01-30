//
//  UIImageView+.swift
//  MovieLike
//
//  Created by 최정안 on 1/28/25.
//

import UIKit
import Kingfisher
extension UIImageView {
    
    func setOptionalImage(imgPath: String?) {
        if let url = imgPath {
            let img = URL(string: url.imagePathFormat())
            self.kf.setImage(with: img)
        }else {
            self.image = UIImage(systemName: "star")
            self.tintColor = .gray
        }
    }
    
    
}
