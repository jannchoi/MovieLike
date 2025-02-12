//
//  SearchViewModel.swift
//  MovieLike
//
//  Created by 최정안 on 2/10/25.
//

import Foundation


class SearchViewModel: BaseViewModel {
    private(set) var input: Input
    private(set) var output: Output
    
    struct Input {
        var searchedTerm: Observable<String?> = Observable(nil)
        var fromSearchButton: Observable<Bool> = Observable(false)
        var prefetchTrigger: Observable<[IndexPath]> = Observable([])
    }
    struct Output {
        var movieList : Observable<[MovieDetail]> = Observable([])
        var errorMessage : Observable<String?> = Observable(nil)
        var isFromSearchButton: Observable<Bool> = Observable(false)
        var searchedMovie: Observable<SearchMovie?> = Observable(nil)
        
        
    }
    var page: Observable<Int> = Observable(1)
    var isEnd: Observable<Bool> = Observable(false)
    
    var isResultEmpty: Bool = false
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        
        input.fromSearchButton.lazyBind { bool in
            print("fromSearchButton")
            self.output.isFromSearchButton.value = bool
        }
        input.prefetchTrigger.lazyBind { indexPaths in
            print("prefetchTrigger")
            self.checkForPrefetch()
        }
        input.searchedTerm.lazyBind { _ in
            print("searchedTerm")
            self.searchButtonClicked()
        }
        
    }
    private func searchButtonClicked() {
        guard let inputText = input.searchedTerm.value else {return}
        let trimmedInputText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        page.value = 1
        output.movieList.value.removeAll()
        if !UserDefaultsManager.searchedTerm.contains(trimmedInputText) {
            UserDefaultsManager.searchedTerm.insert(trimmedInputText, at: 0)
        }
        callForRequest()
    }
    
    private func checkForPrefetch() {
        for item in input.prefetchTrigger.value {
            if output.movieList.value.count - 4 <= item.row && isEnd.value == false {
                page.value += 1
                callForRequest()
            }
        }
    }
    
    private func callForRequest() {
        guard let inputText = input.searchedTerm.value else {return}
        NetworkManager.shared.callRequst(api: .searchMovie(query: inputText, page: page.value), model: SearchMovie.self) {
            response in
            switch response {
            case .success(let value) :
                if self.page.value > value.total_pages {
                    self.isEnd.value = true
                    return
                }
                self.isResultEmpty = value.results.isEmpty
                if self.page.value == 1{
                    self.output.movieList.value = value.results
                } else {
                    self.output.movieList.value.append(contentsOf: value.results)
                }
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
