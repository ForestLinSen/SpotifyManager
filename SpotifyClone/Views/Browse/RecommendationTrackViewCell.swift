//
//  RecommendationTrackViewCell.swift
//  SpotifyClone
//
//  Created by Sen Lin on 27/2/2022.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell{
    static let identifier = "RecommendedTrackCollectionViewCell"
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        //label.backgroundColor = .systemRed
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        //label.backgroundColor = .systemBlue
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(imageView)
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.frame.height - 20
        let labelHeight = contentView.frame.height / 5
        let labelWidth = contentView.frame.width / 3
        
        imageView.frame = CGRect(x: 10, y: 10, width: imageSize, height: imageSize)
        trackNameLabel.frame = CGRect(x: imageSize + 20, y: 10, width: labelWidth, height: labelHeight)
        artistNameLabel.frame = CGRect(x: imageSize + 20, y: labelHeight+10, width: labelWidth, height: labelHeight)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: RecommendationCellViewModel){
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        imageView.sd_setImage(with: viewModel.imageURL)
    }
}
