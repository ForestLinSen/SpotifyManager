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
    
    // MARK: - User Profile
    
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
    
    
    // MARK: - New releases
    
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
    
    
    // MARK: - Playlists
    
    public func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void){
        let requestString = K.baseAPIURL + "/browse/featured-playlists?limit=10"
        createRequest(with: URL(string: requestString), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
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
    
    
    // MARK: - Track
    
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
                
                let recommendationString = K.baseAPIURL + "/recommendations?limit=15&seed_genres=\(genresString)"
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
    
    
    // MARK: - Album details
    func getAlbumDetail(albumID: String, completion: @escaping (Result<AlbumDetailResponse, Error>) -> Void){
        let requestString = K.baseAPIURL + "/albums/\(albumID)"
        
        createRequest(with: URL(string: requestString), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                //print("Debug: request string \(requestString)")
                
                guard let data = data, error == nil else{
                    print("Debug: error in fetching album: \(error)")
                    completion(.failure(APIError.failedToGetData))
                    return
                }

                do{
                    //let jsonData = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    //print("Debug: album detail \(jsonData)")
                    
                    let albumDetail = try JSONDecoder().decode(AlbumDetailResponse.self, from: data)
                    print("Debug: album detail: \(albumDetail)")
                    completion(.success(albumDetail))
                    
                }catch{
                    completion(.failure(APIError.failedToConvertData))
                    print("Debug: error in fetching album: \(error)")
                }
                
            }
            
            task.resume()
        }
    }
    
    
    // MARK: - Playlist details
    func getPlaylistDetail(playlistID: String, completion: @escaping (Result<PlaylistDetailResponse, Error>) -> Void){
        let requestString = K.baseAPIURL + "/playlists/\(playlistID)"
        
        createRequest(with: URL(string: requestString), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    
                    let playlistDetail = try JSONDecoder().decode(PlaylistDetailResponse.self, from: data)
                    
                    //print("Debug: playlist detail: \(playlistDetail)")
                    completion(.success(playlistDetail))
                    
                }catch{
                    print("Debug: Error in converting playlist detail into swift model: \(error)")
                    completion(.failure(APIError.failedToConvertData))
                }
            }
            
            task.resume()
        }
    }
    
    
    // MARK: - Caregories & Category Playlists
    func getCategories(completion: @escaping (Result<CategoriesResponse, Error>) -> Void){
        let requestString = K.baseAPIURL + "/browse/categories"
        createRequest(with: URL(string: requestString), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request){data, _, error in
                
                guard let data = data else {
                    print("Debug: cannot get genre data: \(error)")
                    return
                }
                
                do{
                    //let json = try JSONSerialization.jsonObject(with: data)
                    
                    let categoryResponse = try JSONDecoder().decode(CategoriesResponse.self, from: data)
                    completion(.success(categoryResponse))
                    //print("Debug: getCategories: \(categoryResponse)")
                    
                    
                }catch{}
            }
            
            task.resume()
        }
    }
    
    func getCategoryPlaylists(id: String, completion: @escaping (Result<CategoryPlaylistsResponse, Error>) -> Void){
        let requestString = K.baseAPIURL + "/browse/categories/\(id)/playlists"
        
        createRequest(with: URL(string: requestString), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data else {
                    print("Debug: cannot get category playlist data: \(error)")
                    return
                }
                
                do{
                    let playlists = try JSONDecoder().decode(CategoryPlaylistsResponse.self, from: data)
                    //let jsonData = try JSONSerialization.jsonObject(with: data)
                    
                    print("Debug: category playlists: \(playlists)")
                    completion(.success(playlists))
                    
                }catch{
                    print("Debug: cannot convert playlist data model: \(error)")
                }
                
            }
            
            task.resume()
        }
    }
    
    
    // MARK: - Search
    func searchQuery(query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void){
        let requestString = K.baseAPIURL + "/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&type=album,playlist,track,artist&limit=2"
        
        
        print("Debug: request string: \(requestString)")
        
        createRequest(with: URL(string: requestString), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(SearchQueryResponse.self, from: data)
                    var searchResults: [SearchResult] = []
                    
                    searchResults.append(contentsOf: result.tracks.items.compactMap{SearchResult.track(model: $0)})
                    searchResults.append(contentsOf: result.playlists.items.compactMap{SearchResult.playlist(model: $0)})
                    searchResults.append(contentsOf: result.albums.items.compactMap{SearchResult.album(model: $0)})
                    searchResults.append(contentsOf: result.artists.items.compactMap{SearchResult.artist(model: $0)})
                    
                    completion(.success(searchResults))
                }catch{
                    print("Debug: cannot conver search model: \(error)")
                }

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
        case failedToConvertData
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
