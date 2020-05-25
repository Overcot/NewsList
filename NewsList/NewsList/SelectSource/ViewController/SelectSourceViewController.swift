//
//  SelectSourceViewController.swift
//  NewsList
//
//  Created by Alex Ivashko on 25.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import UIKit

final class SelectSourceViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(SelectSourceListCell.self, forCellReuseIdentifier: "com.overcot.SelectSourceViewController.SelectSourceListCell")
        return tableView
    }()
    
    private var viewModel: SelectSourceViewModelProtocol!
    
    // MARK: - Initializers
    init(viewModel: SelectSourceViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
// MARK: - SelectSourceViewController Lifecycle
extension SelectSourceViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupSubviews()
    }
}

// MARK: - Private Functions
extension SelectSourceViewController {
    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func setupViewModel() {
        title = viewModel.title
    }
}


// MARK: - Protocol Conformance
// MARK: - UITableViewDataSource
extension SelectSourceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "com.overcot.SelectSourceViewController.SelectSourceListCell") else {
            return UITableViewCell()
        }
        if let cell = cell as? SelectSourceListCell {
//            cell.item = viewModel.item(forIndexPath: indexPath)
        }
        return cell
    }
}
// MARK: - UITableViewDelegate
extension SelectSourceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(indexPath: indexPath)
    }
}
