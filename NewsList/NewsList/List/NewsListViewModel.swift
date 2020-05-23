//
//  NewsListViewModel.swift
//  NewsList
//
//  Created by Alex Ivashko on 23.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import Foundation

protocol NewsListViewModelProtocol {
    func numberOfSections() -> Int
    func numberOfRows(inSection section: Int) -> Int
}

final class NewsListViewModel {
    
}

// MARK: - Protocol Conformance
// MARK: - NewsListViewModelProtocol
extension NewsListViewModel: NewsListViewModelProtocol {
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        3
    }
}
