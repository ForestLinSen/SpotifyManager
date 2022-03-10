//
//  PlaylistHeaderCollectionReusableView.swift
//  SpotifyClone
//
//  Created by Sen Lin on 6/3/2022.
//

import UIKit
import SDWebImage

protocol PlaylistHeaderCollectionReusableViewDelegate: UIViewController{
    func didTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

class PlaylistHeaderCollectionReusableView: UICollectionReusableView{
    static let identifier = "PlaylistHeaderCollectionReusable"
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "photo")
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .systemGray
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.layer.cornerRadius = 23
        button.clipsToBounds = true
        
        return button
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(ownerLabel)
        addSubview(descriptionLabel)
        addSubview(playButton)
        
        playButton.addTarget(self, action: #selector(playAllButtonTapped), for: .touchUpInside)
        
    }
    
    @objc private func playAllButtonTapped(){
        self.delegate?.didTapPlayAll(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = frame.width / 3
        let margin: CGFloat = frame.width/15
        let labelWidth = frame.width/2
        let labelHeight = frame.height/5
        let buttonSize = imageSize/3
        
        imageView.frame = CGRect(x: margin, y: 10, width: imageSize, height: imageSize)
        nameLabel.frame = CGRect(x: imageSize + margin*2, y: 10, width: labelWidth, height: labelHeight)
        ownerLabel.frame = CGRect(x: imageSize + margin*2, y: labelHeight, width: labelWidth, height: labelHeight)
        descriptionLabel.frame = CGRect(x: imageSize + margin*2, y: labelHeight*2, width: labelWidth, height: labelHeight*2)
        
        playButton.frame = CGRect(x: imageSize,
                                  y: labelHeight*3.1,
                                  width: buttonSize,
                                  height: buttonSize)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: PlaylistHeaderViewModel){
        nameLabel.text = viewModel.name
        ownerLabel.text = viewModel.owner
        descriptionLabel.text = viewModel.description
        imageView.sd_setImage(with: URL(string: viewModel.imageURL))
    }
}
