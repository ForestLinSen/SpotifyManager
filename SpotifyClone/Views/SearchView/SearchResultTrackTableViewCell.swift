//
//  SearchResultTrackTableViewCell.swift
//  SpotifyClone
//
//  Created by Sen Lin on 17/3/2022.
//

import UIKit
import SDWebImage

class SearchResultTrackTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultTrackTableViewCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = .systemGreen
        return imageView
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let secondLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconImageView)
        contentView.addSubview(mainLabel)
        contentView.addSubview(secondLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.frame.height / 1.3
        let padding = contentView.frame.height / 5
        
        iconImageView.frame = CGRect(x: 15, y: contentView.frame.height/2 - imageSize/2,
                                     width: imageSize, height: imageSize)
        mainLabel.frame = CGRect(x: imageSize * 1.5, y: padding, width: contentView.frame.width - imageSize - 10, height: imageSize/3)
        secondLabel.frame = CGRect(x: imageSize * 1.5, y: imageSize/3, width: contentView.frame.width - imageSize - 10, height: imageSize)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        mainLabel.text = nil
        secondLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: SearchResultTrackViewCellViewModel){
        iconImageView.sd_setImage(with: URL(string: viewModel.imageURL))
        mainLabel.text = viewModel.mainLabel
        secondLabel.text = viewModel.secondLabel
    }
    
    func configure(with trackName: String){
        iconImageView.image = UIImage(systemName: "music.note")
        mainLabel.text = trackName
    }
    
}
