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
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var item: NewsListItem? {
        didSet {
            guard let item = item else {
                timeLabel.text = ""
                titleLabel.text = ""
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, dd MMM yyyy H:mm:ss Z"
            timeLabel.text = dateFormatter.string(from: item.publicationDate)
            titleLabel.text = item.title
        }
    }
    
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
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.leading.equalToSuperview().offset(16.0)
        }
        contentView.addSubview(titleLabel)
        titleLabel.snp.contentHuggingVerticalPriority = 249
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(8.0)
            make.leading.equalTo(timeLabel)
            make.trailing.lessThanOrEqualToSuperview().inset(8.0)
            make.bottom.equalToSuperview().inset(8.0)
        }
    }
}
