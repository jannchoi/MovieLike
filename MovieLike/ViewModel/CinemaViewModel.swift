//
//  CinemaViewModel.swift
//  MovieLike
//
//  Created by 최정안 on 2/5/25.
//

import Foundation
final class CinemaViewModel: BaseViewModel {
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
        loadData()
        self.input.resetSearchedTermTapped.lazyBind { [weak self] _ in // 검색어 삭제 버튼을 눌렀을 때
            self?.resetSearchedTerm()
            self?.switchSearchedTermView()
        }
        self.input.updateSearchedTerm.bind { [weak self] _ in // userdefault의 검색어가 변경되면 뷰모델 내부 프로퍼티도 업데이트
            self?.userdefaultsSearchedTerm.value = UserDefaultsManager.searchedTerm
            self?.switchSearchedTermView()
        }
        userdefaultsSearchedTerm.bind { [weak self] _ in // 검색어가 비어있는지 상태 여부
            self?.switchSearchedTermView()
        }
        input.deleteSearchedTerm.lazyBind { [weak self] target in // 검색어가 삭제될 때 userdefault와 내부 프로퍼티 업데이트
            guard let target else {return}
            UserDefaultsManager.searchedTerm.remove(at: target)
            self?.input.updateSearchedTerm.value = ()
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
