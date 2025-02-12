//
//  ProfileViewModel.swift
//  MovieLike
//
//  Created by 최정안 on 2/12/25.
//

import Foundation

final class ProfileViewModel: BaseViewModel {
    private(set) var input: Input
    private(set) var output: Output
    
    struct Input {
        
    }
    struct Output {
        var category = ["자주 묻는 질문", "1:1문의", "알림 설정", "탈퇴하기"]
    }
    
    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    func transform() {
        //
    }
}
