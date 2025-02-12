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
        var nickname: Observable<String?> = Observable(UserDefaultsManager.nickname)
        var selectedButtons: Observable<[(String?,Int?)]> = Observable([(nil, nil),(nil, nil),(nil, nil),(nil, nil)])
        
    }
    struct Output {
        var image: Observable<String> = Observable("")
        var nicknameIsValid: Observable<Bool> = Observable(false)
        var descriptionLabel: Observable<String> = Observable("")
        var preparedNickname: Observable<String> = Observable("")
        var isButtonEnable: Observable<Bool> = Observable(false)
        var preparedMBTI: Observable<[Int]> = Observable([])
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
        setSavedProfile()
        
        input.finishButtonTrigger.lazyBind { _ in
            self.saveData()
        }
        input.nickname.lazyBind { _ in
            self.isValidNickname()
            self.checkIsButtonEnable()
        }
        input.selectedButtons.lazyBind { _ in
            self.checkMbtiIsValid()
            self.checkIsButtonEnable()
        }
    }
    private func setSavedProfile() {
        setProfileImage()
        prepareNickname()
        setMBTI()
        checkIsButtonEnable()
    }
    private func checkIsButtonEnable() {
        output.isButtonEnable.value = output.nicknameIsValid.value && mbtiIsValid
    }
    
    private func checkMbtiIsValid() {
        let mbtilist = input.selectedButtons.value.map{$0.0}
        if mbtilist.contains(nil) {
            mbtiIsValid = false
        } else {
            mbtiIsValid = true
        }
    }
    private func prepareNickname() {
        if UserDefaultsManager.nickname != "None" {
            input.nickname.value = UserDefaultsManager.nickname
            output.preparedNickname.value = UserDefaultsManager.nickname
        } else {
            output.preparedNickname.value = ""
        }
        isValidNickname()
    }
    private func setProfileImage() {
        if initialImage != UserDefaultsManager.profileImage && UserDefaultsManager.profileImage != 0 {
            output.image.value = "profile_\(initialImage)"
        } else {
            initialImage = UserDefaultsManager.profileImage
            output.image.value = "profile_\(initialImage)"
        }
    }
    private func setMBTI() {
        if UserDefaultsManager.used {
            guard let list = UserDefaultsManager.mbti.first else {return}
            output.preparedMBTI.value = list.value
            for i in 0...3 {
                input.selectedButtons.value[i] = (list.key[i], list.value[i])
            }
            print(input.selectedButtons.value)
            checkMbtiIsValid()
        }
    }
    private func saveData() {
        guard let nickname = input.finishButtonTrigger.value
        else {return}
        if !UserDefaultsManager.used {
            UserDefaultsManager.signDate = Date().DateToString()
        }
        UserDefaultsManager.nickname = nickname
        UserDefaultsManager.profileImage = initialImage
        UserDefaultsManager.used = true
        let mbtiKey = input.selectedButtons.value.compactMap{$0.0}.joined()
        let mbtiValue = input.selectedButtons.value.compactMap{$0.1}
        UserDefaultsManager.mbti = [mbtiKey : mbtiValue]
        
        

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
