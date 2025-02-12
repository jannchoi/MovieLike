//
//  UserDefaultsManager.swift
//  MovieLike
//
//  Created by 최정안 on 1/27/25.
//

import Foundation

@propertyWrapper struct MyDefaults<T> {
    
    let key: String
    let empty: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? empty
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}

enum UserDefaultsManager {
    enum Key: String {
        case used, nickname, profileImage, signDate, like, searchedTerm, mbti
    }
    
    @MyDefaults(key: Key.used.rawValue, empty: false)
    static var used
    @MyDefaults(key: Key.nickname.rawValue, empty: "None")
    static var nickname
    @MyDefaults(key: Key.profileImage.rawValue, empty: 0)
    static var profileImage
    @MyDefaults(key: Key.signDate.rawValue, empty: "None")
    static var signDate
    @MyDefaults(key: Key.like.rawValue, empty: [Int]())
    static var like
    @MyDefaults(key: Key.searchedTerm.rawValue, empty: [String]())
    static var searchedTerm
    @MyDefaults(key: Key.mbti.rawValue, empty: [String : [Int]]())
    static var mbti
}
