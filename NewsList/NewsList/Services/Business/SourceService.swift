//
//  SourceService.swift
//  NewsList
//
//  Created by Alex Ivashko on 25.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import Foundation

protocol SourceServiceProtocol {
    func getSourcesList(completion: @escaping ([SourceItem]) -> Void)
}

final class SourceService {
    private let coreDataService: CoreDataServiceProtocol
    
    // MARK: - Initializers
    init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
    }
}

// MARK: - Protocol Conformance
// MARK: - SourceServiceProtocol
extension SourceService: SourceServiceProtocol {
    func getSourcesList(completion: @escaping ([SourceItem]) -> Void) {
        coreDataService.getEntities(using: nil, sortedUsing: nil) { (sources: [Source]) in
            completion(sources.compactMap {
                guard let link = $0.rssLink else {
                    return nil
                }
                return SourceItem(link: link, isSelected: $0.isSelected)
            })
        }
    }
}
