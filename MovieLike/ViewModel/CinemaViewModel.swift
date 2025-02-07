//
//  CinemaViewModel.swift
//  MovieLike
//
//  Created by 최정안 on 2/5/25.
//

import Foundation
class CinemaViewModel {
    
    var movieList: Observable<[MovieDetail]> = Observable([])
    var errorMessage: Observable<String?> = Observable(nil)
    
    var userdefaultsSearchedTerm: Observable<[String]> =  Observable(UserDefaultsManager.shared.searchedTerm)
    
    var inputResetSearchedTermTapped: Observable<Void> = Observable(())
    var inputUpdateSearchedTerm: Observable<Void> = Observable(())
    
    var isShowSearchedWords: Observable<Bool> = Observable(false)
    
    init() {
        self.movieList.bind { _ in
            self.loadData()
        }
        self.inputResetSearchedTermTapped.bind { _ in
            self.resetSearchedTerm()
            self.switchSearchedTermView()
        }
        self.inputUpdateSearchedTerm.bind { _ in
            self.userdefaultsSearchedTerm.value = UserDefaultsManager.shared.searchedTerm
        }
        
        
    }
    private func resetSearchedTerm() {
        UserDefaultsManager.shared.searchedTerm.removeAll()
    }
    private func switchSearchedTermView() {
        if self.userdefaultsSearchedTerm.value.isEmpty {
            self.isShowSearchedWords.value = false
        }
        else {
            self.isShowSearchedWords.value = true
        }
    }
    
    private func loadData() {
        NetworkManager.shared.callRequst(api: .todayMovie, model: TrendMovie.self) { response in
            switch response {
            case .success(let value) :
                self.movieList.value = value.results
                self.errorMessage.value = nil
            case .failure(let failure) :
                if let errorType = failure as? NetworkError {
                    self.errorMessage.value = errorType.errorMessage
                }
            }
        }
    }
    
}
