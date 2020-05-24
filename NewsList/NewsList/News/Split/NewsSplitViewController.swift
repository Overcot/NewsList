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
    init(listViewController: UIViewController,
         detailViewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        viewControllers = [listViewController, detailViewController]
        delegate = self
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
        view.backgroundColor = .systemBackground
    }
}
// MARK: - Protocol Conformance
// MARK: - UISplitViewControllerDelegate
extension NewsSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(
             _ splitViewController: UISplitViewController,
             collapseSecondary secondaryViewController: UIViewController,
             onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        return true
    }
}
