//
//  AuthManager.swift
//  Spotify Clone
//
//  Created by Leonardo Cruz on 03/06/22.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    struct Constants {
        static let clientID = "aec48e72ca6a40bbbd3036e1ac9869b3"
        static let clientSecret = "cdf5193ce51744248808f1c5a3293858"
    }
    
    private init() {}
    
    var isSignedIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
}
