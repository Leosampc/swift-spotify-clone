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
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else { return false }
        let fiveMinutes: TimeInterval = 300
        return Date().addingTimeInterval(fiveMinutes) >= expirationDate
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
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    public func refreshAccessToken() {
        
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.set(result.access_token, forKey: "access_token")
        UserDefaults.standard.set(result.refresh_token, forKey: "refresh_token")
        UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
}
