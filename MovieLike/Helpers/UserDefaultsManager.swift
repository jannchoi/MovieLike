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
    
    var nickname: String {  // default: false
        get {
            UserDefaults.standard.string(forKey: "nickname") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "nickname")
        }
    }
    var profileImage: Int {
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
    var like: Bool {
        get {
            UserDefaults.standard.bool(forKey: "like")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "like")
        }
    }
    
    var info: [String] {
        get {
            UserDefaults.standard.array(forKey: "info") as? [String] ?? ["NO NAME","NO DATE","NO LEVEL"]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "info")
        }
    }
}
