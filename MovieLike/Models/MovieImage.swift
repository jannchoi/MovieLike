//
//  MovieImage.swift
//  MovieLike
//
//  Created by 최정안 on 1/28/25.
//

import Foundation

struct MovieImage: Decodable {
    let backdrops: [FileDetail]
    let posters: [FileDetail]
}
struct FileDetail: Decodable {
    let file_path: String?
}
