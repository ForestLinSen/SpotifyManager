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
        
        createRequest(with: URL(string: K.baseAPIURL + "/me"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    print("Debug: cannot decode user profile")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
//                     let jsonData = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                     print("Debug: json data of user profile \(jsonData)")
//                    print("Debug: begin to convert user profile")
                    let profile = try JSONDecoder().decode(UserProfile.self, from: data)
                    print("Debug: user profile data model: \(profile)")
                    completion(.success(profile))
                }catch{
                    print("Cannot convert user profile model: \(error)")
                }
            }
            
            task.resume()
        }
    }
    
    public func getReleases(completion: @escaping (Result<NewReleasesResponse, Error>) -> Void){
        
        let requestString = K.baseAPIURL + "/browse/new-releases?limit=10"
        
        createRequest(with: URL(string: requestString), type: .GET) { request in
            let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    let releases = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    
                    completion(.success(releases))
                    
                }catch{
                    completion(.failure(APIError.failedToGetData))
                    print("Debug: release response error: \(error)")
                }
                
            }
            
            dataTask.resume()
        }
    }
    
    
    public func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void){
        let requestString = K.baseAPIURL + "/browse/featured-playlists?limit=10"
        createRequest(with: URL(string: requestString), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
//                    let jsonData = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                    print("Debug: featured playlists: \(jsonData)")
                    
                    let featuredReleases = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(.success(featuredReleases))
                    
                }catch{
                    print("Debug: cannot fetch featured releases: \(error)")
                    completion(.failure(APIError.failedToGetData))
                }
            }
            
            task.resume()
            
        }
    }
    
    public func getRecommendation(completion: @escaping (Result<RecommendationResponse, Error>) -> Void){
        getGenres {[weak self] result in
            switch result{
            case .success(let genres ):
                var genreSeed = Set<String>()
                
                while(genreSeed.count < 5){
                    if let genre = genres.genres.randomElement(){
                        genreSeed.insert(genre)
                    }
                }
                
                let genresString = genreSeed.joined(separator: ",")
                
                let recommendationString = K.baseAPIURL + "/recommendations?limit=10&seed_genres=\(genresString)"
                //print("Debug: recommendation url: \(recommendationString)")
                self?.createRequest(with: URL(string: recommendationString), type: .GET) { request in
                    let task = URLSession.shared.dataTask(with: request) { data, _, error in
                        guard let data = data, error == nil else{
                            completion(.failure(APIError.failedToGetData))
                            print("Debug: error getting recommendation: \(error)")
                            return
                        }
                        
                        do{
                            let recommendation = try JSONDecoder().decode(RecommendationResponse.self, from: data)
                            //print("Debug: recommendation \(recommendation)")
                            
                            completion(.success(recommendation))
                        }catch{}
                        
                        
                    }
                    task.resume()
                }
                
                
            case .failure(_):
                break
            }
        }
    }
    
    
    public func getGenres(completion: @escaping (Result<Genres, Error>) -> Void){
        let requestString = K.baseAPIURL + "/recommendations/available-genre-seeds"
        
        createRequest(with: URL(string: requestString), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
       
                    let genres = try JSONDecoder().decode(Genres.self, from: data)
                    completion(.success(genres))
                    
                }catch{}

            }
            
            task.resume()
        }
    }
    
    
    // MARK: - Private
    enum HTTPMethod: String{
        case GET
        case POST
    }
    
    enum APIError: Error{
        case failedToGetData
    }
    
    
    //https://developer.spotify.com/documentation/general/guides/authorization/use-access-token/
    public func createRequest(with url: URL?,
                              type: HTTPMethod,
                              completion: @escaping (URLRequest) -> Void){
        
        AuthManager.shared.withValideToken { token in
            
            guard let apiURL = url else { return }
            
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
            
        }
    }
}
