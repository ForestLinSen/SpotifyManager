//
//  NewReleasesResponse.swift
//  SpotifyClone
//
//  Created by Sen Lin on 22/2/2022.
//

import Foundation

struct NewReleasesResponse: Codable{
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable{
    let items: [Album]
}

struct Album: Codable{
    let album_type: String
    let artists: [Artist]
    let id: String
    let images: [APIImage]
    let name: String
    let release_date: String
    let total_tracks: Int
    let type: String
    let uri: String
}

struct Artist: Codable{
    let id: String
    let name: String
    let type: String
}
