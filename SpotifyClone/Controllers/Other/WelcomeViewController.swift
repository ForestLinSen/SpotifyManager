//
//  WelcomeViewController.swift
//  SpotifyClone
//
//  Created by Sen Lin on 11/2/2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign in with Spotify", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Spotify"
        
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        print("Debug: welcome screen did load")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = view.frame.width
        let height = view.frame.height
        let buttonWidth = width/1.4
        let buttonHeight = buttonWidth/6
        signInButton.frame = CGRect(x: width/2 - buttonWidth/2, y: height - buttonHeight*2.2,
                                   width: buttonWidth, height: buttonHeight)
    }
    
    @objc func didTapSignInButton(){
        print("Debug: sign in button tapped")
        let vc = AuthViewController()
        vc.completionHandler = {[weak self] success in
            self?.handleSignIn(success: success)
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleSignIn(success: Bool){
        
    }

}
