//
//  String+.swift
//  MovieLike
//
//  Created by 최정안 on 1/27/25.
//

import Foundation
extension String {
    func dateFormat() -> String? {
        let inputFormat = DateFormatter()
        inputFormat.dateFormat = "yyyy-MM-dd"
        let outputFormat = DateFormatter()
        outputFormat.dateFormat = "yyyy.MM.dd"
        
        if let date = inputFormat.date(from: self) {
            return outputFormat.string(from: date)
        } else {
            return nil
        }
    }
    func imagePathFormat() -> String {
        return "https://image.tmdb.org/t/p/w500" + self
    }
}
