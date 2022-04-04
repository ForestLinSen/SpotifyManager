//
//  FeaturePlaylistCollectionView.swift
//  SpotifyClone
//
//  Created by Sen Lin on 27/2/2022.
//

import UIKit

class FeaturePlaylistCollectionViewCell: UICollectionViewCell{
    static let identifier = "RecommendationTrackCollectionViewCell"
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(ownerLabel)
        contentView.addSubview(playlistNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.frame.height / 1.7
        let labelHeight = contentView.frame.height / 5
        let labelWidth = contentView.frame.width / 1.5
        
        imageView.frame = CGRect(x: contentView.frame.width/2 - imageSize/2,
                                 y: 10,
                                 width: imageSize,
                                 height: imageSize)
        
        playlistNameLabel.frame = CGRect(x: contentView.frame.width/2 - labelWidth/2,
                                         y: imageSize+10,
                                         width: labelWidth,
                                         height: labelHeight)
        
        ownerLabel.frame = CGRect(x: contentView.frame.width/2 - labelWidth/2,
                                  y: imageSize+labelHeight,
                                  width: labelWidth,
                                  height: labelHeight)
        
        contentView.clipsToBounds = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        ownerLabel.text = nil
        playlistNameLabel.text = nil
    }
    
    func configure(with viewModel: FeaturePlaylistCellViewModel){
        imageView.sd_setImage(with: viewModel.imageURL)
        playlistNameLabel.text = viewModel.name
        ownerLabel.text = viewModel.creatorName
    }
    
}
