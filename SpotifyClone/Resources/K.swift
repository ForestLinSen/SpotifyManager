//
//  K.swift
//  SpotifyClone
//
//  Created by Sen Lin on 12/2/2022.
//

import Foundation

struct K{
    static let clientID = Bundle.main.infoDictionary!["CLIENT_ID"] as! String
    static let clientSecret = Bundle.main.infoDictionary!["CLIENT_SECRET"] as! String
    static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    static let redirectURI = "https://www.google.com/"
}
