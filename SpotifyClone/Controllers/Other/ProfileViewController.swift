//
//  ProfileViewController.swift
//  SpotifyClone
//
//  Created by Sen Lin on 18/2/2022.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        print("Debug: profile view")
        self.title = "Profile"
        APICaller.shared.getCurrentUserProfile { result in
            switch result{
            case .success(_):
                break
            case .failure(let error):
                print("Debug: error in fetching user profile \(error.localizedDescription)")
            }
        }
    }
}
