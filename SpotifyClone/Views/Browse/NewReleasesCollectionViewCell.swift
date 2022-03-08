//
//  NewReleasesCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Sen Lin on 27/2/2022.
//

import UIKit
import SDWebImage

//struct NewReleasesCellViewModel{
//    let name: String
//    let artworkURL: URL?
//    let numberOfTracks: Int
//    let artistName: String
//}

class NewReleaseCollectionViewCell: UICollectionViewCell{
    static let identifier = "NewReleaseCollectionViewCell"
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 10
        
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.clipsToBounds = true
        
        let imageSize = contentView.frame.height - 10
        let labelHeight = contentView.frame.height / 5
        
        imageView.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        
        albumNameLabel.frame = CGRect(x: imageView.frame.width + imageView.frame.origin.x + 10,
                                      y: 10,
                                      width: contentView.frame.width - imageSize,
                                      height: labelHeight)
        //albumNameLabel.backgroundColor = .systemRed
        
        artistNameLabel.frame = CGRect(x: imageView.frame.width + imageView.frame.origin.x + 10,
                                       y: albumNameLabel.frame.origin.y + albumNameLabel.frame.height,
                                       width:  contentView.frame.width - imageSize,
                                       height: labelHeight)
        //artistNameLabel.backgroundColor = .systemBlue
        
        numberOfTracksLabel.frame = CGRect(x: imageView.frame.width + imageView.frame.origin.x + 10,
                                           y: contentView.frame.height - labelHeight*1.5,
                                           width:  contentView.frame.width - imageSize,
                                           height: labelHeight)
        //numberOfTracksLabel.backgroundColor = .systemMint
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        imageView.image = nil
    }
    
    func configure(with viewModel: NewReleasesCellViewModel){
        albumNameLabel.text = viewModel.name
        numberOfTracksLabel.text = "Tracks: \(String(viewModel.numberOfTracks))"
        artistNameLabel.text = viewModel.artistName
        
        imageView.sd_setImage(with: viewModel.artworkURL)
    }
}
