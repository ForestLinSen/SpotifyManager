//
//  SearchResultDefaultTableViewCell.swift
//  SpotifyClone
//
//  Created by Sen Lin on 16/3/2022.
//

import UIKit
import SDWebImage

class SearchResultDefaultTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultDefaultTableViewCell"
    var imageSize: CGFloat = 0.0
    
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
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconImageView)
        contentView.addSubview(mainLabel)
        
        imageSize = contentView.frame.height / 1.3
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.frame = CGRect(x: 15, y: contentView.frame.height/2 - imageSize/2,
                                     width: imageSize, height: imageSize)
        mainLabel.frame = CGRect(x: imageSize * 1.8, y: 0, width: contentView.frame.width - imageSize - 10, height: contentView.frame.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        mainLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: SearchResultDefaultTableViewCellViewModel){
        iconImageView.sd_setImage(with: URL(string: viewModel.imageURL))
        mainLabel.text = viewModel.mainLabel
    }
    
    func configure(with trackName: String){
        iconImageView.image = UIImage(systemName: "music.note")
        mainLabel.text = trackName
    }
    
    func configureAvatar(with viewModel: SearchResultDefaultTableViewCellViewModel){
        iconImageView.sd_setImage(with: URL(string: viewModel.imageURL))
        iconImageView.layer.cornerRadius = imageSize/2
        iconImageView.clipsToBounds = true
        mainLabel.text = viewModel.mainLabel
    }
    
}
