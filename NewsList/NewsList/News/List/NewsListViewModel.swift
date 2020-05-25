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
    var didMarkNewsAsReadedAt: ((IndexPath) -> Void)? { get set }
    var showError: ((String, String) -> Void)? { get set }
    
    func numberOfSections() -> Int
    func numberOfRows(inSection section: Int) -> Int
    func item(forIndexPath indexPath: IndexPath) -> NewsItem?
    func didSelectRowAt(indexPath: IndexPath)
    func refreshNewsList()
}

final class NewsListViewModel {
    // MARK: - Private variables
    private let newsFetchService: NewsServiceProtocol
    private weak var coordinator: NewsViewCoordinator?
    
    private var list: [NewsItem] = []
    var link: String = "https://www.banki.ru/xml/news.rss" {
        didSet {
            refreshNewsList()
        }
    }
    var didUpdateNewsList: (() -> Void)?
    var didMarkNewsAsReadedAt: ((IndexPath) -> Void)?
    var showError: ((String, String) -> Void)?
    
    // MARK: - Initializers
    init(newsFetchService: NewsServiceProtocol, coordinator: NewsViewCoordinator?) {
        self.newsFetchService = newsFetchService
        self.coordinator = coordinator
        refreshNewsList()
    }
}

// MARK: - Private Functions
extension NewsListViewModel {
    private func updateView() {
        DispatchQueue.main.async { [weak self] in
            self?.didUpdateNewsList?()
        }
    }
    private func updateCell(at indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            self?.didMarkNewsAsReadedAt?(indexPath)
        }
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
    func item(forIndexPath indexPath: IndexPath) -> NewsItem? {
        list[safe: indexPath.row]
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        guard let item = list[safe: indexPath.row] else {
            return
        }
        list[indexPath.row].isReaded = true
        updateCell(at: indexPath)
        coordinator?.select(item: item)
        newsFetchService.markNewsAsReaded(item)
    }
    
    func refreshNewsList() {
        newsFetchService.getSortedNewsList(from: link) { [weak self] result in
            switch result {
            case let .success(newsList):
                self?.list = newsList
                self?.updateView()
                
            case .failure:
                DispatchQueue.main.async { [weak self] in
                    self?.showError?("Ошибка", "Произошла ошибка при загрузке новостей")
                }
            }
        }
    }
}
