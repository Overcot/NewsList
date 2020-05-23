//
//  NewsSplitViewController.swift
//  NewsList
//
//  Created by Alex Ivashko on 23.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import UIKit

final class NewsSplitViewController: UISplitViewController {
    // MARK: - Private variables
    // MARK: - Initializers
    init(listViewController: NewsListViewController, detailViewController: NewsDetailViewController) {
        super.init(nibName: nil, bundle: nil)
        viewControllers = [listViewController, detailViewController]
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - NewsSplitViewController Lifecycle
extension NewsSplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredDisplayMode = .allVisible
    }
}
