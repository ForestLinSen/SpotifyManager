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
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.alpha = 0.9
        button.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        return button
    }()
    
    private let bgImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "albumGrids")
        
        return imageView
    }()
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "logoAlpha")
        
        return imageView
    }()
    
    private let slogan: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Music for everyone."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        return label
    }()
    
    private let overlay: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.8
        return view
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Spotify"
        
        view.addSubview(bgImage)
        view.addSubview(overlay)
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        view.addSubview(logo)
        view.addSubview(slogan)
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
        
        bgImage.frame = view.bounds
        overlay.frame = view.bounds
        
        let logoWidth = view.frame.width / 2.8
        logo.frame = CGRect(x: view.frame.width/2 - logoWidth/2, y: view.frame.height/2-logoWidth, width: logoWidth, height: logoWidth)
        slogan.frame = CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: logoWidth/2)
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
        guard success else {
            let alert = UIAlertController(title: "Oops",
                                          message: "Something went wrong when signin",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }

}
