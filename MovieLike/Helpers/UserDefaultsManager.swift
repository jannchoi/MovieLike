//
//  UserDefaultsManager.swift
//  MovieLike
//
//  Created by 최정안 on 1/27/25.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() { }
    
    var nickname: String {  // default: nil
        get {
            UserDefaults.standard.string(forKey: "nickname") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "nickname")
        }
    }
    var profileImage: Int { // default: 0
        get {
            UserDefaults.standard.integer(forKey: "profileImage")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "profileImage")
        }
    }
    var signDate: String{
        get {
            UserDefaults.standard.string(forKey: "signDate") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "signDate")
        }
    }

    var like: [Int] {
        get {
            UserDefaults.standard.array(forKey: "like") as? [Int] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "like")
        }
    }
    var searchedTerm: [String] {
        get {
            UserDefaults.standard.array(forKey: "searchedTerm") as? [String] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "searchedTerm")
        }
    }
}
