//
//  WelcomeViewController.swift
//  SpotifyClone
//
//  Created by Sen Lin on 11/2/2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        //button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Spotify"
        
        view.backgroundColor = .systemGreen
        view.addSubview(loginButton)
        print("Debug: welcome screen did load")
        
        let clientID = Bundle.main.infoDictionary?["CLIENT_ID"]
        let clientSecret = Bundle.main.infoDictionary?["CLIENT_SECRET"]
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = view.frame.width
        let height = view.frame.height
        let buttonWidth = width/1.4
        let buttonHeight = buttonWidth/6
        loginButton.frame = CGRect(x: width/2 - buttonWidth/2, y: height - buttonHeight*2.2,
                                   width: buttonWidth, height: buttonHeight)
    }

}
