//
//  SelectSourceCoordinator.swift
//  NewsList
//
//  Created by Alex Ivashko on 23.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import UIKit

final class SelectSourceCoordinator: BaseCoordinator<String> {
    private let splitViewController: UISplitViewController
    
    // MARK: - Initializers
    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
    }

    override func start(completion: @escaping ((String) -> Void)) {
        completion("https://www.banki.ru/xml/news.rss")
    }
}
