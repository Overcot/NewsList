//
//  NewsListViewModel.swift
//  NewsList
//
//  Created by Alex Ivashko on 23.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import Foundation

protocol NewsListViewModelProtocol {
    
    var didUpdateNewsList: (() -> Void)? { get set }
    
    func numberOfSections() -> Int
    func numberOfRows(inSection section: Int) -> Int
    func item(forIndexPath indexPath: IndexPath) -> NewsListItem?
}

final class NewsListViewModel {
    // MARK: - Private variables
    private let newsFetchService: NewsFetchServiceProtocol
    
    private var list: [NewsListItem] = [] {
        didSet {
            didUpdateNewsList?()
        }
    }
        
    var didUpdateNewsList: (() -> Void)?
    
    // MARK: - Initializers
    init(newsFetchService: NewsFetchServiceProtocol) {
        self.newsFetchService = newsFetchService
        newsFetchService.getSortedNewsList(from: "https://www.banki.ru/xml/news.rss") { [weak self] result in
            switch result {
            case let .success(newsList):
                self?.list = newsList
                
            case .failure:
                break
            }
        }
    }
}

// MARK: - Protocol Conformance
// MARK: - NewsListViewModelProtocol
extension NewsListViewModel: NewsListViewModelProtocol {
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        list.count
    }
    func item(forIndexPath indexPath: IndexPath) -> NewsListItem? {
        list[safe: indexPath.row]
    }
}
