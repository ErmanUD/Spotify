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
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize?"
        let scope = "user-read-private"
        let redirect = "https://eksisozluk.com/"
        let dialog = "show_dialog=TRUE"
        let string = "\(base)response_type=code&client_id=\(Constants.clientID)&scope=\(scope)&redirect_uri=\(redirect)&\(dialog)"
        
        return URL(string: string)
    }
    
    
    var isSignedIn: Bool {
        return false
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
