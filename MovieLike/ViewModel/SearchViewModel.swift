//
//  SearchViewModel.swift
//  MovieLike
//
//  Created by 최정안 on 2/10/25.
//

import Foundation


final class SearchViewModel: BaseViewModel {
    private(set) var input: Input
    private(set) var output: Output
    
    struct Input {
        var searchedTerm: Observable<String?> = Observable(nil) // 검색어
        var fromSearchButton: Observable<Bool> = Observable(false) // 돋보기 버튼으로 들어왔는지
        var prefetchTrigger: Observable<[IndexPath]> = Observable([]) // pagination을 위한 트리거
        var searchedIdx: Observable<Int?> = Observable(nil) // 선택된 셀의 idx
    }
    struct Output {
        var movieList : Observable<[MovieDetail]> = Observable([])
        var errorMessage : Observable<String?> = Observable(nil)
        var isFromSearchButton: Observable<Bool> = Observable(false)
        var outputSearchedIdx: Observable<Int?> = Observable(nil)
        
        
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
        input.searchedIdx.lazyBind {[weak self] input in // cell이 선택되었을 때
            guard let input else {return}
            self?.output.outputSearchedIdx.value = input
        }
        
        input.fromSearchButton.lazyBind {[weak self] bool in // 돋보기 버튼으로 들어왔는지
            print("fromSearchedButton", self?.output.isFromSearchButton.value)
            self?.output.isFromSearchButton.value = bool
        }
        input.prefetchTrigger.lazyBind {[weak self] indexPaths in // pagination을 위한 트리거
            self?.checkForPrefetch()
        }
        input.searchedTerm.lazyBind {[weak self] _ in // 검색어가 입력되었을 때
            self?.searchButtonClicked()
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
