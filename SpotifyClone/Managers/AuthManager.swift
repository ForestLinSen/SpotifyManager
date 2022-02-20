//
//  AuthManager.swift
//  SpotifyClone
//
//  Created by Sen Lin on 11/2/2022.
//

import Foundation

final class AuthManager{
    static let shared = AuthManager()
    
    private var refreshingToken = false
    
    private init(){}
    
    var isSignedIn: Bool{
        return accessToken != nil
    }
    
    public var signinURL: URL?{
        // https://developer.spotify.com/documentation/general/guides/authorization/code-flow/
        
        let scope = K.scope
        let baseURL = "https://accounts.spotify.com/authorize?"
        let urlString = "\(baseURL)response_type=code&client_id=\(K.clientID)&scope=\(scope)&redirect_uri=\(K.redirectURI)&show_dialog=TRUE"
        return URL(string: urlString)
        
    }
    
    private var accessToken: String?{
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String?{
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date?{
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool{
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        
        let currentData = Date()
        let fiveMinutes: TimeInterval = 300
        return currentData.addingTimeInterval(fiveMinutes) >= expirationDate

    }
    

    
    /// Get token
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)){
        
        guard let url = URL(string: K.tokenAPIURL) else { return }
        
        var components = URLComponents()
        
        // Each URLQueryItem represents a single key-value pair
        // https://developer.spotify.com/documentation/general/guides/authorization/code-flow/
        // grant_type, code, redirect_uri
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: K.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = "\(K.clientID):\(K.clientSecret)"
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Debug: cannot get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do{
                //let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                print("Debug: json data: \(result)")
                completion(true)
                
            }catch{
                print("Debug: error serialization \(error.localizedDescription)")
                completion(false)
            }
        }
        
        task.resume()
    }
    
    
    private var onRefreshBlocks = [(String) -> Void]()
    
    public func withValideToken(completion: @escaping (String) -> Void){
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        
        if shouldRefreshToken{
            refreshTokenIfNeeded { [weak self] success in
                
                if let token = self?.accessToken, success{
                    completion(token)
                }
            }
        }else if let token = accessToken{
            
            completion(token)
        }
    }
    
    
    public func refreshTokenIfNeeded(completion: @escaping (Bool) -> Void){
        // make sure we are not in the process of refreshing token
        guard !refreshingToken else { return }
        
        guard shouldRefreshToken, let refreshToken = self.refreshToken else {
            print("Debug: refresh token \(self.refreshToken)")
            completion(false)
            return
        }
        
        guard let url = URL(string: K.tokenAPIURL) else { return }
        
        // begin to refresh token
        self.refreshingToken = true
        
        var components = URLComponents()
        
        // Each URLQueryItem represents a single key-value pair
        // https://developer.spotify.com/documentation/general/guides/authorization/code-flow/
        // grant_type, code, redirect_uri
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = "\(K.clientID):\(K.clientSecret)"
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Debug: cannot get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do{
                //let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                self?.refreshingToken = false
                self?.onRefreshBlocks.forEach{$0(result.access_token)}
                self?.onRefreshBlocks.removeAll()
                print("Debug: refreshTokenIfNeeded json data: \(result)")
                
            }catch{
                print("Debug: refreshTokenIfNeeded error serialization \(error.localizedDescription)")
                completion(false)
            }
        }
        
        
        task.resume()
    }
    
    public func cacheToken(result: AuthResponse){
        UserDefaults.standard.set(result.access_token, forKey: "access_token")
        
        if let refreshToken = result.refresh_token {
            UserDefaults.standard.set(refreshToken, forKey: "refresh_token")
        }

        UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }

}
