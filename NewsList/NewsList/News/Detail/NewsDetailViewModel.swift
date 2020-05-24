//
//  NewsDetailViewModel.swift
//  NewsList
//
//  Created by Alex Ivashko on 24.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import Foundation

protocol NewsDetailViewModelProtocol {
    var viewControllerTitle: String { get }
    var title: String { get }
    var description: String { get }
}

final class NewsDetailViewModel {
    private let model: NewsItem
    init(model: NewsItem) {
        self.model = model
    }
}


// MARK: - Protocol Conformance
// MARK: - NewsDetailViewModelProtocol
extension NewsDetailViewModel: NewsDetailViewModelProtocol {
    var viewControllerTitle: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM yyyy H:mm:ss Z"
        return dateFormatter.string(from: model.publicationDate)
    }
    var title: String {
        model.title
    }
    var description: String {
        model.description
    }
}
