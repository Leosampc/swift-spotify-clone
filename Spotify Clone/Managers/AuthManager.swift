//
//  AuthManager.swift
//  Spotify Clone
//
//  Created by Leonardo Cruz on 03/06/22.
//

import Foundation
import SpotifyWebAPI

final class AuthManager {
    static let shared = AuthManager()
    
    struct Constants {
        static let baseURL = "https://accounts.spotify.com"
        static let clientID = "aec48e72ca6a40bbbd3036e1ac9869b3"
        static let clientSecret = "cdf5193ce51744248808f1c5a3293858"
        static let redirectURI = "http://www.cooperativa-cocrafi.com.br"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let scope = "user-read-private"
        let queryStringURL = "\(Constants.baseURL)/authorize?response_type=code&client_id=\(Constants.clientID)&scope=\(scope)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: queryStringURL)
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
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
        guard let url = URL(string: "\(Constants.baseURL)/api/token") else { return }
        
        let basicToken = "\(Constants.clientID):\(Constants.clientSecret)"
        let tokenData = basicToken.data(using: .utf8)
        guard let base64Token = tokenData?.base64EncodedString() else {
            print("Failed to get base64Token")
            completion(false)
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64Token)", forHTTPHeaderField: "Authorization")
        request.httpBody = components.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print("SUCCESS: \(json)")
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    public func refreshAccessToken() {
        
    }
    
    private func cacheToken() {
        
    }
}
