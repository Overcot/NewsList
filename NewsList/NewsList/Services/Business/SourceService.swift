//
//  SourceService.swift
//  NewsList
//
//  Created by Alex Ivashko on 25.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import CoreData
import Foundation

enum SourceServiceError: Error {
    case alreadyExists
    
    case errorSaving
}

protocol SourceServiceProtocol {
    func getSourcesList(completion: @escaping ([SourceItem]) -> Void)
    func markAsSelected(_ source: SourceItem)
    func createNewSource(link: String, completion: @escaping (Result<SourceItem, SourceServiceError>) -> Void)
    func getSelectedSource(completion: @escaping (SourceItem?) -> Void)
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
    func markAsSelected(_ source: SourceItem) {
        coreDataService.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest = Source.fetchRequest()
            do {
                let _ = try context.fetch(fetchRequest).forEach { $0.isSelected = false }
                
                fetchRequest.predicate = NSPredicate(format: "rssLink == %@", source.link)
                let result = try context.fetch(fetchRequest)
                result.first?.isSelected = true
                
                if context.hasChanges {
                    try context.save()
                }
            } catch {
            }
        }
    }
    func createNewSource(link: String, completion: @escaping (Result<SourceItem, SourceServiceError>) -> Void) {
        coreDataService.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest = Source.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "rssLink == %@", link)
            guard let count = try? context.count(for: fetchRequest), count == 0 else {
                return completion(.failure(.alreadyExists))
            }
            guard let source = NSEntityDescription.insertNewObject(forEntityName: "Source", into: context) as? Source else {
                return
            }
            source.rssLink = link
            source.isSelected = false
            do {
                if context.hasChanges {
                    try context.save()
                }
                completion(.success(SourceItem(link: link, isSelected: false)))
            } catch {
                completion(.failure(.errorSaving))
            }
        }
    }
    func getSelectedSource(completion: @escaping (SourceItem?) -> Void) {
        coreDataService.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest = Source.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isSelected == %@", NSNumber(booleanLiteral: true))
            guard let res = try? context.fetch(fetchRequest), let source = res.first else {
                return completion(nil)
            }
            guard let link = source.rssLink else {
                return completion(nil)
            }
            completion(SourceItem(link: link, isSelected: source.isSelected))
        }
    }
}
