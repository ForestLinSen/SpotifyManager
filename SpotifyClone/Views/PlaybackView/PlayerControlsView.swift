//
//  PlayerControlsView.swift
//  SpotifyClone
//
//  Created by Sen Lin on 19/3/2022.
//

import UIKit

protocol PlayerControlsViewDelegate: AnyObject{
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlsView(_ playerControlView: PlayerControlsView, sliderDidChange value: Float)
}


struct PlayerControlsViewModel{
    let trackName: String
    let artistName: String
}


class PlayerControlsView: UIView {
    
    weak var delegate: PlayerControlsViewDelegate?
    private var isPlaying = true
    
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
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
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
        let image = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 36))
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
        addSubview(volumeSlider)
        
        addSubview(previousButton)
        addSubview(playButton)
        addSubview(nextButton)
        
        playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(didTapPreviousButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        
        volumeSlider.addTarget(self, action: #selector(sliderDidChanged(_:)), for: .valueChanged)
    }
    
    @objc private func didTapPlayButton(){
        delegate?.playerControlsViewDidTapPlayPauseButton(self)
        
        isPlaying = !isPlaying
        let image = UIImage(systemName:  isPlaying ? "pause.fill" : "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 36))
        
        
        playButton.setImage(image, for: .normal)
    }
    
    @objc private func didTapPreviousButton(){
        delegate?.playerControlsViewDidTapBackwardButton(self)
    }
    
    @objc private func didTapNextButton(){
        delegate?.playerControlsViewDidTapForwardButton(self)
    }
    
    @objc private func sliderDidChanged(_ slider: UISlider){
        let value = slider.value
        delegate?.playerControlsView(self, sliderDidChange: value)
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
        
        volumeSlider.frame = CGRect(x: padding, y: frame.height/3, width: frame.width-padding*2, height: elementHeight)
        
        playButton.frame = CGRect(x: frame.width/2-buttonWidth/2, y: volumeSlider.frame.origin.y + elementHeight,
                                  width: buttonWidth,
                                  height: elementHeight)
        previousButton.frame = CGRect(x: frame.width*0.25 - buttonWidth/2, y: volumeSlider.frame.origin.y + elementHeight, width: buttonWidth, height: elementHeight)
        nextButton.frame = CGRect(x: frame.width*0.75 - buttonWidth/2, y: volumeSlider.frame.origin.y + elementHeight, width: buttonWidth, height: elementHeight)
        
        nameLabel.frame = CGRect(x: frame.width/2 - textWidth/2, y: frame.height/12, width: textWidth, height: labelHeight)
        subtitleLabel.frame = CGRect(x: frame.width/2 - textWidth/2, y: frame.height/12 + labelHeight, width: textWidth, height: labelHeight)
        
    }
    
    func configure(with viewModel: PlayerControlsViewModel){
        nameLabel.text = viewModel.trackName
        subtitleLabel.text = viewModel.artistName
    }
    
}
