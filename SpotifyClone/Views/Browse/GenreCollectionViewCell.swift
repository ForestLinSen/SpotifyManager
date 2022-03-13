//
//  GenreCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Sen Lin on 12/3/2022.
//

import UIKit
import SDWebImage

class GenreCollectionViewCell: UICollectionViewCell {
    static let identifier = "GenreCollectionViewCell"
    
    private let genreImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "music.quarternote.3",
                              withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        genreLabel.text = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(genreImageView)
        addSubview(genreLabel)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = frame.width / 2.5
        let labelWidth = frame.width / 1.8
        genreImageView.frame = CGRect(x: frame.width - imageSize - 10, y: 10, width: imageSize, height: imageSize)
        genreLabel.frame = CGRect(x: 15, y: frame.height - 30, width: labelWidth, height: 20)
        genreImageView.layer.cornerRadius = 15
    }
    
    
    func configure(title: String, color: UIColor = .systemPink){
        genreLabel.text = title
        backgroundColor = color
    }
    
    func configure(title: String, imageURL: String, color: UIColor = .systemPink){
        genreLabel.text = title
        backgroundColor = color
        genreImageView.sd_setImage(with: URL(string: imageURL))
    }
    
}
