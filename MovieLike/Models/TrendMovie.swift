//
//  TrendMovie.swift
//  MovieLike
//
//  Created by 최정안 on 1/27/25.
//

import Foundation

struct TrendMovie: Decodable {
    let results : [MovieDetail]
}

struct MovieDetail: Decodable {
    let id : Int
    let title : String
    let overview : String?
    let poster_path : String?
    let genre_ids : [Int]
    let release_date : String?
    let vote_average : Double?
}
