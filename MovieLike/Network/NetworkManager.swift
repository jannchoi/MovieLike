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
    
    func callRequst<T: Decodable>(api: TMDBRequest, model: T.Type,vc: UIViewController, completionHandler: @escaping(T) -> Void) {
        
        AF.request(api.endpoint, method: api.method, headers: api.header)
            .validate(statusCode: 200...200)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completionHandler(value)
                case .failure(let error) :
                    let alert = UIAlertController(title: "오류", message: self.getErrorMessage(code: response.response?.statusCode ?? 501), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                    vc.present(alert, animated: true)
                    print(error)
                }
            }
    }
    
    private func getErrorMessage(code: Int) -> String{
        switch code {
        case 400 : return NetworkError.badRequest.errorMessage
        case 401 : return NetworkError.unauthorized.errorMessage
        case 403 : return NetworkError.forbidden.errorMessage
        case 404 : return NetworkError.notFound.errorMessage
        case 500 : return NetworkError.serverError.errorMessage
        default :
            return "Unknown error"
        }
    }
}
