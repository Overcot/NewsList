//
//  NewsListViewController.swift
//  NewsList
//
//  Created by Alex Ivashko on 22.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import SnapKit
import UIKit

final class NewsListViewController: UIViewController {
    // MARK: - Private Variables
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsListCell.self, forCellReuseIdentifier: "com.overcot.NewsList.NewsListCell")
        tableView.refreshControl = self.refreshControl
        return tableView
    }()
}
// MARK: - NewsListViewController Lifecycle
extension NewsListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
}

// MARK: - Private Functions
extension NewsListViewController {
    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


// MARK: - Protocol Conformance
// MARK: - UITableViewDataSource
extension NewsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "com.overcot.NewsList.NewsListCell") else {
            return UITableViewCell()
        }
        return cell
    }
}
// MARK: - UITableViewDelegate
extension NewsListViewController: UITableViewDelegate {
    
}
