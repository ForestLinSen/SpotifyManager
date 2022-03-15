//
//  SearchresultViewController.swift
//  SpotifyClone
//
//  Created by Sen Lin on 15/3/2022.
//

import UIKit

class SearchresultViewController: UIViewController{

    private var results = [SearchResult]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = .systemTeal
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with results: [SearchResult]){
        self.results = results
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.tableView.isHidden = false
        }

    }
}

extension SearchresultViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.backgroundColor = .systemRed
        return cell
    }
}
