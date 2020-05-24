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
    
    override func start(completion: @escaping ((Void) -> Void)) {
        let viewModel = NewsListViewModel(newsFetchService: NewsFetchService(), coordinator: self)
        let listViewController = NewsListViewController(viewModel: viewModel)
        let masterNavigationController = UINavigationController(rootViewController: listViewController)
        masterNavigationController.navigationBar.prefersLargeTitles = true
        splitViewController = NewsSplitViewController(
            listViewController: masterNavigationController,
            detailViewController: UINavigationController(rootViewController: PlaceholderViewController())
        )
        window?.rootViewController = splitViewController
        guard let splitViewController = splitViewController else {
            return completion(Void())
        }
        let selectSourceCoordinator = SelectSourceCoordinator(splitViewController: splitViewController)
        coordinate(to: selectSourceCoordinator) { [weak viewModel] str in
            viewModel?.link = str
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
}
