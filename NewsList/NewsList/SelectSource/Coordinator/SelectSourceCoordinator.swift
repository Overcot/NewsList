//
//  SelectSourceCoordinator.swift
//  NewsList
//
//  Created by Alex Ivashko on 23.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import UIKit

protocol SelectSourceCoordinatorProtocol {
    func userDidSelectSource()
}

final class SelectSourceCoordinator: BaseCoordinator<String> {
    private let splitViewController: UISplitViewController
    private var completion: ((String) -> Void)?
    
    // MARK: - Initializers
    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
    }

    override func start(completion: @escaping ((String) -> Void)) {
        self.completion = completion
        let navController = UINavigationController(rootViewController: SelectSourceViewController(viewModel: SelectSourceViewModel(coordinator: self, sourceService: SourceService(coreDataService: CoreDataService()))))
        splitViewController.present(navController, animated: true, completion: nil)
    }
}

// MARK: - Protocol Conformance
// MARK: - SelectSourceCoordinatorProtocol
extension SelectSourceCoordinator: SelectSourceCoordinatorProtocol {
    func userDidSelectSource() {
        splitViewController.dismiss(animated: true, completion: nil)
        self.completion?("https://www.banki.ru/xml/news.rss")
    }
}
