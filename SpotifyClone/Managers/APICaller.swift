//
//  APICaller.swift
//  SpotifyClone
//
//  Created by Sen Lin on 17/2/2022.
//

import Foundation

final class APICaller{
    static let shared = APICaller()
    
    private init(){}
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void){
        
    }
    
    
    //https://developer.spotify.com/documentation/general/guides/authorization/use-access-token/
    public func createRequest(with url: URL?, completion: @escaping (URLRequest) -> Void){
        AuthManager.shared.withValideToken { token in
            guard let apiURL = url else { return }
            
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
        }
    }
}
