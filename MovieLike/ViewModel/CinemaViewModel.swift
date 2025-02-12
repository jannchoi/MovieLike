//
//  CinemaViewModel.swift
//  MovieLike
//
//  Created by 최정안 on 2/5/25.
//

import Foundation
class CinemaViewModel: BaseViewModel {
    private(set) var input: Input
    private(set) var output: Output
    
    struct Input{
        var resetSearchedTermTapped: Observable<Void> = Observable(())
        var updateSearchedTerm: Observable<Void> = Observable(())
        var deleteSearchedTerm: Observable<Int?> = Observable(nil)
        
    }
    struct Output {
        var movieList: Observable<[MovieDetail]> = Observable([])
        var errorMessage: Observable<String?> = Observable(nil)
        var isShowSearchedWords: Observable<Bool> = Observable(false)
    }
    
    var userdefaultsSearchedTerm: Observable<[String]> =  Observable(UserDefaultsManager.searchedTerm)
    
    init() {
        input = Input()
        output = Output()
        transform()    }
    func transform() {
        self.output.movieList.bind { _ in
            self.loadData()
        }
        self.input.resetSearchedTermTapped.lazyBind { _ in
            self.resetSearchedTerm()
            self.switchSearchedTermView()
        }
        self.input.updateSearchedTerm.bind { _ in
            self.userdefaultsSearchedTerm.value = UserDefaultsManager.searchedTerm
            self.switchSearchedTermView()
        }
        userdefaultsSearchedTerm.bind { _ in
            self.switchSearchedTermView()
        }
        input.deleteSearchedTerm.lazyBind { target in
            guard let target else {return}
            UserDefaultsManager.searchedTerm.remove(at: target)
            self.userdefaultsSearchedTerm.value = UserDefaultsManager.searchedTerm
        }
    }
    private func resetSearchedTerm() {
        UserDefaultsManager.searchedTerm.removeAll()
    }
    private func switchSearchedTermView() {
        if self.userdefaultsSearchedTerm.value.isEmpty {
            self.output.isShowSearchedWords.value = false
        }
        else {
            self.output.isShowSearchedWords.value = true
        }
    }
    
    private func loadData() {
        NetworkManager.shared.callRequst(api: .todayMovie, model: TrendMovie.self) { response in
            switch response {
            case .success(let value) :
                self.output.movieList.value = value.results
                self.output.errorMessage.value = nil
            case .failure(let failure) :
                if let errorType = failure as? NetworkError {
                    self.output.errorMessage.value = errorType.errorMessage
                }
            }
        }
    }
    
}
