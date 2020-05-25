//
//  NewsViewCoordinator.swift
//  NewsList
//
//  Created by Alex Ivashko on 23.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import UIKit

final class NewsViewCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow?
    private var splitViewController: UISplitViewController?
    
    // MARK: - Initializers
    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start(completion: @escaping ((()) -> Void)) {
        let viewModel = NewsListViewModel(newsService: NewsService(coreDataService: CoreDataService()), coordinator: self)
        let listViewController = NewsListViewController(viewModel: viewModel)
        let masterNavigationController = UINavigationController(rootViewController: listViewController)
        masterNavigationController.navigationBar.prefersLargeTitles = true
        splitViewController = NewsSplitViewController(
            listViewController: masterNavigationController,
            detailViewController: UINavigationController(rootViewController: PlaceholderViewController())
        )
        window?.rootViewController = splitViewController
        guard let _ = splitViewController else {
            return completion(Void())
        }
    }
    func select(item: NewsItem?) {
        guard let item = item else {
            return
        }
        let detailViewModel = NewsDetailViewModel(model: item)
        splitViewController?.showDetailViewController(
            UINavigationController(rootViewController: NewsDetailViewController(viewModel: detailViewModel)),
            sender: nil
        )
    }
    
    func selectNewsSource() {
        guard let splitViewController = splitViewController else {
            return
        }
        let selectSourceCoordinator = SelectSourceCoordinator(splitViewController: splitViewController)
        coordinate(to: selectSourceCoordinator) { _ in }
    }
}
