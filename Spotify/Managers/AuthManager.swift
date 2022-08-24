//
//  AuthManager.swift
//  Spotify
//
//  Created by Erman Ufuk Demirci on 24.08.2022.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    var isSignedIn: Bool {
        return true
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var expirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
}
