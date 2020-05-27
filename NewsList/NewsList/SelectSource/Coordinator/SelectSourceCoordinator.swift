//
//  SelectSourceCoordinator.swift
//  NewsList
//
//  Created by Alex Ivashko on 23.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import UIKit

protocol SelectSourceCoordinatorProtocol: AnyObject {
    func userDidSelect(source: SourceItem)
}

final class SelectSourceCoordinator: BaseCoordinator<SourceItem> {
    private let splitViewController: UISplitViewController
    private var completion: ((SourceItem) -> Void)?
    
    // MARK: - Initializers
    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
    }

    override func start(completion: @escaping ((SourceItem) -> Void)) {
        self.completion = completion
        let sourceVC = Assembly.container.resolve(SelectSourceViewController.self)!
        let navController = UINavigationController(rootViewController: sourceVC)
        splitViewController.present(navController, animated: true, completion: nil)
    }
}

// MARK: - Protocol Conformance
// MARK: - SelectSourceCoordinatorProtocol
extension SelectSourceCoordinator: SelectSourceCoordinatorProtocol {
    func userDidSelect(source: SourceItem) {
        splitViewController.dismiss(animated: true, completion: nil)
        self.completion?(source)
    }
}
