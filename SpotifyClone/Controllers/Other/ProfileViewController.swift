//
//  ProfileViewController.swift
//  SpotifyClone
//
//  Created by Sen Lin on 18/2/2022.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController{
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        
        return tableView
    }()
    
    private var models = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Profile"
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            switch result{
            case .success(let model):
                DispatchQueue.main.async {
                    self?.updateUI(with: model)
                }
            case .failure(let error):
                print("Debug: error in fetching user profile \(error.localizedDescription)")
                self?.failedToGetProfile()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    private func updateUI(with model: UserProfile){
        tableView.isHidden = false
        models.append(model.display_name)
        models.append(model.email)
        models.append(model.product)
        createHeaderView(with: model.images.first?.url)
        tableView.reloadData()
    }
    
    private func createHeaderView(with string: String?){
        guard let urlString = string, let url = URL(string: urlString) else { return }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/6))

        let imageSize = headerView.frame.width / 4
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageSize/2
        imageView.clipsToBounds = true
        
        headerView.addSubview(imageView)
        imageView.sd_setImage(with: url)
        
        tableView.tableHeaderView = headerView
        
    }
    
    private func failedToGetProfile(){
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = models[indexPath.row]
        cell.contentConfiguration = config
        print("Debug: cell text: \(models[indexPath.row])")
        
        return cell
    }
    
    
    
    
}
