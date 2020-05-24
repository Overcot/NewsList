//
//  BaseCoordinator.swift
//  NewsList
//
//  Created by Alex Ivashko on 23.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import Foundation

protocol CoordinatorType {
    associatedtype CoordinationResult
    var identifier: UUID { get }
    func start(completion: @escaping ((CoordinationResult) -> Void))
}

class BaseCoordinator<ResultType>: CoordinatorType {
    typealias CoordinationResult = ResultType
    
    var identifier: UUID = UUID()
    
    private var childCoordinators = [UUID: Any]()

    private func store<T: CoordinatorType>(coordinator: T) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func free<T: CoordinatorType>(coordinator: T) {
        childCoordinators[coordinator.identifier] = nil
    }

    func coordinate<T: CoordinatorType, U>(to coordinator: T, completion: @escaping ((U) -> Void)) where U == T.CoordinationResult {
        store(coordinator: coordinator)
        coordinator.start { [weak self] (result: U) in
            self?.free(coordinator: coordinator)
            completion(result)
        }
    }

    func start(completion: @escaping ((ResultType) -> Void)) {
        fatalError("Subclass must implement this method")
    }
}
