//
//  SettingsModels.swift
//  SpotifyClone
//
//  Created by Sen Lin on 19/2/2022.
//

import Foundation

struct Section{
    let title: String
    let options: [Option]
}

struct Option{
    let title: String
    let handler: ()->Void
}
