//
//  UserProfile.swift
//  SpotifyClone
//
//  Created by Sen Lin on 17/2/2022.
//

import Foundation

struct UserProfile: Codable{
    let country: String
    let display_name: String
    let email: String
    
    // https://stackoverflow.com/questions/53020762/expected-to-decode-int-but-found-a-number-instead/53022724#53022724
    // The error message is very misleading. This happens when the JSON contains a boolean value, and the struct has an Int property for the corresponding key.
    let explicit_content: [String: Bool]
    let external_urls: [String: String]
    //let followers: [String: Codable?]
    let id: String
    let images: [UserImage]
    let product: String
    let uri: String
    
}

struct UserImage: Codable{
    let url: String
}
