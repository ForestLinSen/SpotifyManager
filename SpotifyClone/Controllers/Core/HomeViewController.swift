//
//  ViewController.swift
//  SpotifyClone
//
//  Created by Sen Lin on 10/2/2022.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapSettings))
    }
    
    @objc func didTapSettings(){
        let vc = ProfileViewController()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

