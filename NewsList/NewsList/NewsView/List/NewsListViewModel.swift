//
//  NewsListViewModel.swift
//  NewsList
//
//  Created by Alex Ivashko on 23.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import Foundation

protocol NewsListViewModelInput: AnyObject {
    var source: SourceItem? { get set }
}

protocol NewsListViewModelOutput {
    var title: String { get }
    var didUpdateNewsList: (() -> Void)? { get set }
    var didMarkNewsAsReadedAt: ((IndexPath) -> Void)? { get set }
    var showError: ((String, String) -> Void)? { get set }
    
    func numberOfRows() -> Int
    func item(forIndexPath indexPath: IndexPath) -> NewsItem?
    func didSelectRowAt(indexPath: IndexPath)
    func refreshNewsList()
    func selectNewsSource()
}

final class NewsListViewModel {
    // MARK: - Private variables
    private let newsService: NewsServiceProtocol
    private let sourceService: SourceServiceProtocol
    
    private var list: [NewsItem] = []
    
    // MARK: - Public Variables
    weak var coordinator: NewsViewCoordinator?

    // MARK: - Input
    var source: SourceItem? {
        didSet {
            refreshNewsList()
        }
    }
    
    // MARK: - Output
    var didUpdateNewsList: (() -> Void)?
    var didMarkNewsAsReadedAt: ((IndexPath) -> Void)?
    var showError: ((String, String) -> Void)?
    
    // MARK: - Initializers
    init(newsService: NewsServiceProtocol, sourceService: SourceServiceProtocol) {
        self.newsService = newsService
        self.sourceService = sourceService
        sourceService.getSelectedSource { [weak self] source in
            self?.source = source
        }
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
// MARK: - NewsListViewModelInput
extension NewsListViewModel: NewsListViewModelInput {}

// MARK: - NewsListViewModelOutput
extension NewsListViewModel: NewsListViewModelOutput {
    var title: String {
        "Новости"
    }
    
    func numberOfRows() -> Int {
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
        newsService.markNewsAsReaded(item)
    }
    
    func refreshNewsList() {
        newsService.getSortedNewsList(from: source) { [weak self] result in
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
    func selectNewsSource() {
        coordinator?.selectNewsSource()
    }
}
