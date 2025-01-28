//
//  MovieCredit.swift
//  MovieLike
//
//  Created by 최정안 on 1/28/25.
//

import Foundation

struct MovieCredit: Decodable{
    let cast : [CastDetail]
}
struct CastDetail:Decodable {
    let name: String?
    let character: String?
    let profile_path: String?
}
