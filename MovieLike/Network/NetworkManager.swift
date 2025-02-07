//
//  NetworkManager.swift
//  MovieLike
//
//  Created by 최정안 on 1/27/25.
//

import UIKit
import Alamofire

enum TMDBRequest {
    case todayMovie
    case searchMovie(query: String, page: Int)
    case movieImage(id: Int)
    case cast(id: Int)
    
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
        case .movieImage(let id) :
            return URL(string: baseURL + "movie/\(id)/images")!
        case .cast(let id) :
            return URL(string: baseURL + "movie/\(id)/credits?language=ko-KR")!
        }
    }
    var method: HTTPMethod {
        return .get
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    func callRequst<T: Decodable>(api: TMDBRequest, model: T.Type, completionHandler: @escaping(Result<T,Error>) -> Void) {
        
        AF.request(api.endpoint, method: api.method, headers: api.header)
            .validate(statusCode: 200...200)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completionHandler(.success(value))
                case .failure(let error) :
                    let code = response.response?.statusCode
                    completionHandler(.failure(self.getErrorMessage(code: code ?? 500)))
                    print(error)
                }
            }
    }
    
    private func getErrorMessage(code: Int) -> NetworkError {
        switch code {
        case 400 : return .badRequest
        case 401 : return .unauthorized
        case 403 : return .forbidden
        case 404 : return .notFound
        default : return .serverError
        }
    }
}
