//
//  NewsListViewModel.swift
//  NewsList
//
//  Created by Alex Ivashko on 23.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import Foundation

protocol NewsListViewModelProtocol {
    var title: String { get }
    var didUpdateNewsList: (() -> Void)? { get set }
    
    var showError: ((String, String) -> Void)? { get set }
    
    func numberOfSections() -> Int
    func numberOfRows(inSection section: Int) -> Int
    func item(forIndexPath indexPath: IndexPath) -> NewsListItem?
    func didSelectRowAt(indexPath: IndexPath)
    func refreshNewsList()
}

final class NewsListViewModel {
    // MARK: - Private variables
    private let newsFetchService: NewsFetchServiceProtocol
    private weak var coordinator: NewsViewCoordinator?
    
    private var list: [NewsListItem] = [] {
        didSet {
            didUpdateNewsList?()
        }
    }
    var link: String = "https://www.banki.ru/xml/news.rss" {
        didSet {
            refreshNewsList()
        }
    }
    var didUpdateNewsList: (() -> Void)?
    var showError: ((String, String) -> Void)?
    
    // MARK: - Initializers
    init(newsFetchService: NewsFetchServiceProtocol, coordinator: NewsViewCoordinator?) {
        self.newsFetchService = newsFetchService
        self.coordinator = coordinator
        refreshNewsList()
    }
}

// MARK: - Protocol Conformance
// MARK: - NewsListViewModelProtocol
extension NewsListViewModel: NewsListViewModelProtocol {
    var title: String {
        "Новости"
    }
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        list.count
    }
    func item(forIndexPath indexPath: IndexPath) -> NewsListItem? {
        list[safe: indexPath.row]
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        coordinator?.select(item: list[safe: indexPath.row])
    }
    
    func refreshNewsList() {
        newsFetchService.getSortedNewsList(from: link) { [weak self] result in
            switch result {
            case let .success(newsList):
                self?.list = newsList
                
            case .failure:
                self?.showError?("asd", "test")
            }
        }
    }
}
