//
//  NewsListCell.swift
//  NewsList
//
//  Created by Alex Ivashko on 23.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import UIKit

final class NewsListCell: UITableViewCell {
    // MARK: - Private variables
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Test"
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
}

// MARK: - Private functions
extension NewsListCell {
    private func setupSubviews() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16.0)
        }
    }
}
