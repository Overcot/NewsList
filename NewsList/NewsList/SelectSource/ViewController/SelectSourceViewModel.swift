//
//  SelectSourceViewModel.swift
//  NewsList
//
//  Created by Alex Ivashko on 25.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import Foundation

protocol SelectSourceViewModelProtocol {
    var title: String { get }
    
    func numberOfRows() -> Int
    
    func didSelectRowAt(indexPath: IndexPath)
}

final class SelectSourceViewModel {
    private weak var coordinator: SelectSourceCoordinator?
    private let sourceService: SourceServiceProtocol
    
    private var sources: [SourceItem] = []
    
    init(coordinator: SelectSourceCoordinator, sourceService: SourceServiceProtocol) {
        self.coordinator = coordinator
        self.sourceService = sourceService
        refreshSourcesList()
    }
}

// MARK: - Protocol Conformance
// MARK: - SelectSourceViewModelProtocol
extension SelectSourceViewModel: SelectSourceViewModelProtocol {
    var title: String {
        "Добавьте или выберите источник"
    }
    func numberOfRows() -> Int {
        sources.count
    }
    
    func refreshSourcesList() {
        sourceService.getSourcesList { [weak self] items in
            self?.sources = items
        }
    }
    func didSelectRowAt(indexPath: IndexPath) {
        coordinator?.userDidSelectSource()
    }
}
