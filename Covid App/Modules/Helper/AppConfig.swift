//
//  AppConfig.swift
//  Covid App
//
//  Created by Baboon on 04/10/2021.
//

import Foundation

class AppConfig: NSObject {
    public static let shared = AppConfig()
    
    func saveAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: Constants.TokenSavedKey)
    }
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: Constants.TokenSavedKey)
    }
    
    func clearAccessToken() {
        UserDefaults.standard.removeObject(forKey: Constants.TokenSavedKey)
    }
}
