//
//  AuthResponse.swift
//  Spotify Clone
//
//  Created by Leonardo Cruz on 04/06/22.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String
    let scope: String
    let token_type: String
}
