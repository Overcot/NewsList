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
        tableView.allowsMultipleSelection = false
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
        setupNavigationBar()
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
        viewModel.updateSourcesList = { [unowned self] in
            self.tableView.reloadData()
        }
        viewModel.presentAlert = { [unowned self] title, message in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
                guard let text = alert.textFields?.first?.text else {
                    return
                }
                self?.viewModel.userDidEnter(newLink: text)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }

            alert.addTextField { textField in
                textField.placeholder = "Введите ссылку rss"
            }
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            self.present(alert, animated: true, completion: nil)
        }
        viewModel.presentError = { [unowned self] title, message in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ОК", style: .default) { _ in }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewsSource))
    }
    
    @objc
    private func addNewsSource() {
        viewModel.addNewsSource()
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
            cell.item = viewModel.item(forIndexPath: indexPath)
        }
        return cell
    }
}
// MARK: - UITableViewDelegate
extension SelectSourceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        viewModel.didSelectRowAt(indexPath: indexPath)
    }
}
