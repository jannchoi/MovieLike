//
//  GenreManager.swift
//  MovieLike
//
//  Created by 최정안 on 1/27/25.
//

import Foundation

class GenreManager {
    static let shared = GenreManager()
    let genres: [Int: String] = [
            28: "액션",
            16: "애니메이션",
            80: "범죄",
            18: "드라마",
            14: "판타지",
            27: "공포",
            9648: "미스터리",
            878: "SF",
            53: "스릴러",
            37: "서부",
            12: "모험",
            35: "코미디",
            99: "다큐멘터리",
            10751: "가족",
            36: "역사",
            10402: "음악",
            10749: "로맨스",
            10770: "TV 영화",
            10752: "전쟁"
        ]
    private init() { }
    
    func getGenre(_ id: Int) -> String? {
        return genres[id]
    }
}
