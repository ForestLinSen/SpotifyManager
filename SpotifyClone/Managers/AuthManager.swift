//
//  AuthManager.swift
//  SpotifyClone
//
//  Created by Sen Lin on 11/2/2022.
//

import Foundation

final class AuthManager{
    static let shared = AuthManager()
    
    private init(){}
    
    var isSignedIn: Bool{
        return false
    }
    
    public var signinURL: URL?{
        // https://developer.spotify.com/documentation/general/guides/authorization/code-flow/
        
        let scope = "user-read-private"
        let baseURL = "https://accounts.spotify.com/authorize?"
        let redirectURL = "https://www.google.com/"
        let urlString = "\(baseURL)response_type=code&client_id=\(K.clientID)&scope=\(scope)&redirect_uri=\(redirectURL)&show_dialog=TRUE"
        return URL(string: urlString)
        
    }
    
    private var accessToken: String?{
        return nil
    }
    
    private var refreshToken: String?{
        return nil
    }
    
    private var tokenExpirationDate: Date?{
        return nil
    }
    
    private var shouldRefreshToken: Bool{
        return false
    }
}
