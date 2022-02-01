//
//  UserDefaultsData.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 9.08.21.
//

import Foundation

class UserDefaultsData {
    static var isUserLoggedIn: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
        }
    }

    static var userEmail: String {
        get {
            UserDefaults.standard.string(forKey: "userEmail") ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "userEmail")
            UserDefaults.standard.synchronize()
        }
    }

    static var userPassword: String {
        get {
            UserDefaults.standard.string(forKey: "userPassword") ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "userPassword")
            UserDefaults.standard.synchronize()
        }
    }

    static var token: String {
        get {
            UserDefaults.standard.string(forKey: "token") ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "token")
            UserDefaults.standard.synchronize()
        }
    }

    static var userID: String {
        get {
            UserDefaults.standard.string(forKey: "userID") ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "userID")
            UserDefaults.standard.synchronize()
        }
    }
}
