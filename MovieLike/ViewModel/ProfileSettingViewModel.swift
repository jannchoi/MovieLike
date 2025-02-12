//
//  ProfileSettingViewModel.swift
//  MovieLike
//
//  Created by 최정안 on 2/12/25.
//

import Foundation
final class ProfileSettingViewModel: BaseViewModel {
    private(set) var input: Input
    private(set) var output: Output
    
    struct Input {
        
        var finishButtonTrigger: Observable<String?> = Observable(nil)
        var nickname: Observable<String?> = Observable(UserDefaultsManager.shared.nickname)
        var selectedButtons: Observable<[String?]> = Observable([nil,nil,nil,nil])
        
    }
    struct Output {
        var image: Observable<String> = Observable("")
        var nicknameIsValid: Observable<Bool> = Observable(false)
        var descriptionLabel: Observable<String> = Observable("")
        var preparedNickname: Observable<String> = Observable("")
        var isButtonEnable: Observable<Bool> = Observable(false)
    }
    
    var isEditMode: Observable<Bool> = Observable(false)
    var mbtiIsValid = false
    var initialImage = Int.random(in: 0...11)
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    func transform() {
        setProfileImage()
        prepareNickname()
        
        input.finishButtonTrigger.bind { _ in
            self.saveData()
        }
        input.nickname.lazyBind { _ in
            self.isValidNickname()
        }
        input.selectedButtons.bind { _ in
            self.checkMbtiIsValid()
            self.checkIsButtonEnable()
        }
    }
    private func checkIsButtonEnable() {
        output.isButtonEnable.value = output.nicknameIsValid.value && mbtiIsValid
    }
    
    private func checkMbtiIsValid() {
        if input.selectedButtons.value.contains(nil) {
            mbtiIsValid = false
        } else {
            mbtiIsValid = true
        }
    }
    private func prepareNickname() {
        if UserDefaultsManager.shared.nickname != "" {
            output.preparedNickname.value = UserDefaultsManager.shared.nickname
            isValidNickname()
        }
    }
    private func setProfileImage() {
        let userdefaults = UserDefaultsManager.shared
        
        if initialImage != userdefaults.profileImage && userdefaults.profileImage != 0 {
            output.image.value = "profile_\(initialImage)"
        } else {
            initialImage = userdefaults.profileImage
            output.image.value = "profile_\(initialImage)"
        }
    }
    private func saveData() {
        guard let nickname = input.finishButtonTrigger.value
        else {return}
        UserDefaultsManager.shared.nickname = nickname
        UserDefaultsManager.shared.profileImage = initialImage
        UserDefaultsManager.shared.used = true
        if !UserDefaultsManager.shared.used {
            UserDefaultsManager.shared.signDate = Date().DateToString()
        }
    }
    private func isValidNickname() {
        guard let input = input.nickname.value else {return}
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        var description : String
        if trimmedInput.count < 2 || trimmedInput.count >= 10 {
            description = "2글자 이상 10글자 미만으로 설정해 주세요."
            output.nicknameIsValid.value = false
        } else if trimmedInput.contains(where: {"@#$%".contains($0)}) {
            description = "닉네임에 @,#,$,%는 포함할 수 없어요."
            output.nicknameIsValid.value = false
        } else if trimmedInput.contains(where: {"1234567890".contains($0)}) {
            description = "닉네임에 숫자는 포함할 수 없어요."
            output.nicknameIsValid.value = false
        } else {
            description = "사용할 수 있는 닉네임이에요."
            output.nicknameIsValid.value = true
        }
        output.descriptionLabel.value = description
    }
}
