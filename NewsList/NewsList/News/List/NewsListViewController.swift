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
        refreshControl.addTarget(self, action: #selector(refreshNewsList), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Обновите список новостей")
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
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
        title = viewModel.title
        viewModel.didUpdateNewsList = { [unowned self] in
            self.tableView.reloadData()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
        viewModel.didMarkNewsAsReadedAt = { [unowned self] indexPath in
            if let newsListCell = self.tableView.cellForRow(at: indexPath) as? NewsListCell {
                newsListCell.item = self.viewModel.item(forIndexPath: indexPath)
            }
        }
        viewModel.showError = { [unowned self] (title: String, message: String) in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "ОК", style: .default) { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }
            alert.addAction(closeAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc
    private func refreshNewsList() {
        viewModel.refreshNewsList()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(indexPath: indexPath)
    }
}
