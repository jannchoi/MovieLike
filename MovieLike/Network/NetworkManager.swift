//
//  NetworkManager.swift
//  MovieLike
//
//  Created by 최정안 on 1/27/25.
//

import Foundation
import Alamofire

enum TMDBRequest {
    case todayMovie
    case searchMovie(query: String, page: Int)
    
    var baseURL: String{
        return "https://api.themoviedb.org/3/"
    }
    var header: HTTPHeaders {
        return ["Authorization": "Bearer \(APIKey.token)" ]
    }
    var endpoint: URL {
        switch self {
        case .todayMovie :
            return URL(string: baseURL + "trending/movie/day?language=ko-KR&page=1" )!
        case .searchMovie(let query, let page) :
            return URL(string: baseURL + "search/movie?query=\(query)&include_adult=false&language=ko-KR&page=\(page)")!
        }
    }
    var method: HTTPMethod {
        return .get
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    func callRequst<T: Decodable>(api: TMDBRequest, model: T.Type, completionHandler: @escaping(T) -> Void, failHandler: @escaping () -> Void) {
        AF.request(api.endpoint, method: api.method, headers: api.header)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completionHandler(value)
                case .failure(let error) :
                    print(error)
                }
            }
    }
}
