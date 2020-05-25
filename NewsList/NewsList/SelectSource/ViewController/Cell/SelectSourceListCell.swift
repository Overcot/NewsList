//
//  SelectSourceListCell.swift
//  NewsList
//
//  Created by Alex Ivashko on 25.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import UIKit

final class SelectSourceListCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "asdasdasd"
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
extension SelectSourceListCell {
    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8.0)
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.lessThanOrEqualToSuperview().inset(8.0)
            make.bottom.equalToSuperview().inset(8.0)
        }
    }
}
