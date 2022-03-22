//
//  PlayerControlsView.swift
//  SpotifyClone
//
//  Created by Sen Lin on 19/3/2022.
//

import UIKit

protocol PlayerControlsViewDelegate: UIViewController{
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView)
}

class PlayerControlsView: UIView {
    
    weak var delegate: PlayerControlsViewDelegate?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "Music Name"
        label.textAlignment = .center
        //label.backgroundColor = .systemYellow
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Artist Name"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        //label.backgroundColor = .systemBlue
        return label
    }()
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        //slider.backgroundColor = .systemMint
        return slider
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 36))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(slider)
        
        addSubview(previousButton)
        addSubview(playButton)
        addSubview(nextButton)
        
        playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(didTapPreviousButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    @objc private func didTapPlayButton(){
        delegate?.playerControlsViewDidTapPlayPauseButton(self)
    }
    
    @objc private func didTapPreviousButton(){
        delegate?.playerControlsViewDidTapBackwardButton(self)
    }
    
    @objc private func didTapNextButton(){
        delegate?.playerControlsViewDidTapForwardButton(self)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding = frame.width/12
        let elementHeight = frame.height/6
        let labelHeight = frame.height/9
        let buttonWidth = frame.width/6
        let textWidth = frame.width/2
        
        slider.frame = CGRect(x: padding, y: frame.height/3, width: frame.width-padding*2, height: elementHeight)
        
        playButton.frame = CGRect(x: frame.width/2-buttonWidth/2, y: slider.frame.origin.y + elementHeight,
                                  width: buttonWidth,
                                  height: elementHeight)
        previousButton.frame = CGRect(x: frame.width*0.25 - buttonWidth/2, y: slider.frame.origin.y + elementHeight, width: buttonWidth, height: elementHeight)
        nextButton.frame = CGRect(x: frame.width*0.75 - buttonWidth/2, y: slider.frame.origin.y + elementHeight, width: buttonWidth, height: elementHeight)
        
        nameLabel.frame = CGRect(x: frame.width/2 - textWidth/2, y: frame.height/12, width: textWidth, height: labelHeight)
        subtitleLabel.frame = CGRect(x: frame.width/2 - textWidth/2, y: frame.height/12 + labelHeight, width: textWidth, height: labelHeight)
        
    }
    
}
