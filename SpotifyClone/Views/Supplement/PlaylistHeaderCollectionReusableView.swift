//
//  PlaylistHeaderCollectionReusableView.swift
//  SpotifyClone
//
//  Created by Sen Lin on 6/3/2022.
//

import UIKit

class PlaylistHeaderCollectionReusableView: UICollectionReusableView{
    static let identifier = "PlaylistHeaderCollectionReusable"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemRed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
