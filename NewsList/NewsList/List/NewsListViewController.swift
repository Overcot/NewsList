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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(NewsListCell.self, forCellReuseIdentifier: "com.overcot.NewsList.NewsListCell")
        tableView.refreshControl = self.refreshControl
        return tableView
    }()
    
    private var viewModel: NewsListViewModelProtocol!
    
    // MARK: - Initializers
    init(viewModel: NewsListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
// MARK: - NewsListViewController Lifecycle
extension NewsListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupSubviews()
    }
}

// MARK: - Private Functions
extension NewsListViewController {
    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func setupViewModel() {
        viewModel.didUpdateNewsList = { [unowned self] in
            self.tableView.reloadData()
        }
    }
}


// MARK: - Protocol Conformance
// MARK: - UITableViewDataSource
extension NewsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "com.overcot.NewsList.NewsListCell") else {
            return UITableViewCell()
        }
        if let cell = cell as? NewsListCell {
            cell.item = viewModel.item(forIndexPath: indexPath)
        }
        return cell
    }
}
// MARK: - UITableViewDelegate
extension NewsListViewController: UITableViewDelegate {
    
}
