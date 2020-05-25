//
//  CoreDataService.swift
//  NewsList
//
//  Created by Alex Ivashko on 25.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import CoreData

protocol CoreDataServiceProtocol {
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
    func getEntities<T>(using predicate: NSPredicate?,
                        sortedUsing sortDescriptors: [NSSortDescriptor]?,
                        completion: @escaping ([T]) -> Void) where T: NSManagedObject
}

final class CoreDataService {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewsList")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}

// MARK: - Protocol Conformance
// MARK: - CoreDataServiceProtocol
extension CoreDataService: CoreDataServiceProtocol {
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
    
    func getEntities<T>(using predicate: NSPredicate?,
                        sortedUsing sortDescriptors: [NSSortDescriptor]?,
                        completion: @escaping ([T]) -> Void) where T : NSManagedObject {
        persistentContainer.performBackgroundTask { context in
            let fetchRequest = T.fetchRequest()
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = sortDescriptors
            guard let result = try? context.fetch(fetchRequest) as? [T] else {
                return
            }
            completion(result)
        }
    }
}
