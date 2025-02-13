//
//  MovieDetailViewModel.swift
//  MovieLike
//
//  Created by 최정안 on 2/12/25.
//

import Foundation

final class MovieDetailViewModel: BaseViewModel {
    private(set) var input: Input
    private(set) var output: Output
    
    struct Input {
        var movieId : Observable<Int?> = Observable(nil)
        var releaseDate : Observable<String> = Observable("")
        var rate : Observable<String> = Observable("")
        var movieTitle : Observable<String> = Observable("")
        var synopsis : Observable<String> = Observable("")
        var genre : Observable<[Int]?> = Observable([])
    }
    struct Output {
        var outputMovieId : Observable<Int?> = Observable(nil)
        var backdropImage : Observable<[FileDetail]> = Observable([])
        var posterImage : Observable<[FileDetail]> = Observable([])
        var castList : Observable<[CastDetail]> = Observable([])
        var errorMessage: Observable<String> = Observable("")
    }
    
    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    func transform() {
        input.movieId.lazyBind {[weak self] _ in // 영화 ID를 받으면 vc로 전달, 네트워크 통신
            self?.output.outputMovieId.value = self?.input.movieId.value
            self?.callRequest()
        }
    }
    private func callRequest() {
        guard let movieID = input.movieId.value else {return}
        NetworkManager.shared.callRequst(api: .movieImage(id: movieID), model: MovieImage.self) { response in
            switch response {
            case .success(let value) :
                self.output.backdropImage.value = value.backdrops
                self.output.posterImage.value = value.posters
            case .failure(let failure) :
                if let errorType = failure as? NetworkError {
                    self.output.errorMessage.value = errorType.errorMessage
                }else {
                    print(failure.localizedDescription)
                }
            }
        }
        NetworkManager.shared.callRequst(api: .cast(id: movieID), model: MovieCredit.self) {
            response in
            switch response {
            case .success(let value) :
                self.output.castList.value = value.cast
            case .failure(let failure) :
                if let errorType = failure as? NetworkError {
                    self.output.errorMessage.value = errorType.errorMessage
                }else {
                    print(failure.localizedDescription)
                }
            }
        }
    }
}
