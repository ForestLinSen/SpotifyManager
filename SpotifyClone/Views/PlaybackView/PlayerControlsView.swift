//
//  PlayerControlsView.swift
//  SpotifyClone
//
//  Created by Sen Lin on 19/3/2022.
//

import UIKit

class PlayerControlsView: UIView {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "Music Name"
        label.backgroundColor = .systemMint
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Artist Name"
        label.backgroundColor = .systemBlue
        return label
    }()
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        slider.backgroundColor = .systemMint
        return slider
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 36))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemRed
        
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(slider)
        
        addSubview(previousButton)
        addSubview(playButton)
        addSubview(nextButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding = frame.width/12
        let elementHeight = frame.height/4
        let buttonWidth = frame.width/6
        slider.frame = CGRect(x: padding, y: frame.height/3, width: frame.width-padding*2, height: elementHeight)
        
        playButton.frame = CGRect(x: frame.width/2-buttonWidth/2, y: slider.frame.origin.y + elementHeight,
                                  width: buttonWidth,
                                  height: elementHeight)
        previousButton.frame = CGRect(x: frame.width*0.25 - buttonWidth/2, y: slider.frame.origin.y + elementHeight, width: buttonWidth, height: elementHeight)
        nextButton.frame = CGRect(x: frame.width*0.75 - buttonWidth/2, y: slider.frame.origin.y + elementHeight, width: buttonWidth, height: elementHeight)
        
    }
    
}
