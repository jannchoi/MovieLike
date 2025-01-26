//
//  Date+.swift
//  MovieLike
//
//  Created by 최정안 on 1/27/25.
//

import Foundation

extension Date {
    func DateToString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        let result = formatter.string(from: self)
        return result
    }
}
