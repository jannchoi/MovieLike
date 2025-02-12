//
//  ProfileImageSettingViewModel.swift
//  MovieLike
//
//  Created by 최정안 on 2/12/25.
//

import Foundation
final class ProfileImageSettingViewModel: BaseViewModel {
    
    private(set) var input: Input
    private(set) var output: Output
    
    struct Input {
        var settingImageTrigger: Observable<Void?> = Observable(nil)
        var passData: Observable<((Int?) -> (Int?))?> = Observable(nil)
        var didSelectedItemIndex: Observable<Int?> = Observable(nil)
    }
    struct Output {
        var selectedItem: Observable<Int?> = Observable(nil)
    }
    var isEditMode: Observable<Bool> = Observable(false)
    init() {
        input = Input()
        output = Output()

        transform()
    }
    func transform() {
        input.settingImageTrigger.lazyBind { [weak self] _ in
            self?.setInitialImage()
        }
        input.didSelectedItemIndex.lazyBind { [weak self] idx in
            self?.updateSelectedItem(idx: idx)
        }
    }
    
    private func setInitialImage() {
        output.selectedItem.value = input.passData.value?(nil)
    }
    private func updateSelectedItem(idx: Int?) {
        output.selectedItem.value = idx
    }
}
