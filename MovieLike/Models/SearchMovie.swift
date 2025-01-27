//
//  SearchMovie.swift
//  MovieLike
//
//  Created by 최정안 on 1/27/25.
//

import Foundation

struct SearchMovie: Decodable {
    let results : [MovieDetail]
    let total_pages : Int
}
