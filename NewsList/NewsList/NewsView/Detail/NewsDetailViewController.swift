//
//  NewsDetailViewController.swift
//  NewsList
//
//  Created by Alex Ivashko on 23.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import UIKit

final class NewsDetailViewController: UIViewController {
    // MARK: - Private variables
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24.0, weight: .heavy)
        return label
    }()
    private lazy var descriptionScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isDirectionalLockEnabled = true
        return scrollView
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private var viewModel: NewsDetailViewModelProtocol!
    
    init(viewModel: NewsDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - NewsDetailViewController Lifecycle
extension NewsDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }
}

// MARK: - Private functions
extension NewsDetailViewController {
    private func setupUI() {
        navigationItem.largeTitleDisplayMode = .never
        view.addSubview(titleLabel)
        view.addSubview(descriptionScrollView)
        descriptionScrollView.addSubview(descriptionLabel)
        titleLabel.snp.contentCompressionResistanceVerticalPriority = 1000
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(16.0)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        descriptionScrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func setupViewModel() {
        title = viewModel.viewControllerTitle
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
}
