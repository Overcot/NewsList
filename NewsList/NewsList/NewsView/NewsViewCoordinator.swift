//
//  NewsViewCoordinator.swift
//  NewsList
//
//  Created by Alex Ivashko on 23.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import UIKit

final class NewsViewCoordinator: BaseCoordinator<Void> {
    // MARK: - Private variables
    private let window: UIWindow?
    private var splitViewController: UISplitViewController?
    private weak var listViewModel: NewsListViewModelInput?
    
    // MARK: - Builders
    private let splitViewControllerBuilder: () -> NewsSplitViewController
    private let listViewControllerBuilder: (NewsListViewModelOutput) -> NewsListViewController
    private let listViewModelBuilder: () -> NewsListViewModelInput
    
    // MARK: - Initializers
    init(window: UIWindow?,
        splitViewControllerBuilder: @escaping () -> NewsSplitViewController,
        listViewControllerBuilder: @escaping (NewsListViewModelOutput) -> NewsListViewController,
        listViewModelBuilder: @escaping () -> NewsListViewModelInput) {
        self.window = window
        self.splitViewControllerBuilder = splitViewControllerBuilder
        self.listViewControllerBuilder = listViewControllerBuilder
        self.listViewModelBuilder = listViewModelBuilder
    }

    override func start(completion: @escaping ((()) -> Void)) {
        let listViewModel = listViewModelBuilder()
        self.listViewModel = listViewModel
        
        splitViewController = splitViewControllerBuilder()
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
        let selectSourceCoordinator = Assembly.container.resolve(SelectSourceCoordinator.self)!
        coordinate(to: selectSourceCoordinator) { [weak listViewModel] source in
            listViewModel?.source = source
        }
    }
}
