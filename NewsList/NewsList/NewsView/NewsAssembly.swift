//
//  NewsAssembly.swift
//  NewsList
//
//  Created by Alex Ivashko on 26.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import Swinject
import UIKit

final class NewsAssembly: Swinject.Assembly {
    func assemble(container: Container) {
        container.register(UIWindow.self) { _ in
            UIWindow()
        }.inObjectScope(.container)
        
        container.register(NewsViewCoordinator.self) { r in
            let window = r.resolve(UIWindow.self)!
            return NewsViewCoordinator(
                window: window,
                splitViewControllerBuilder: {
                    r.resolve(NewsSplitViewController.self)!
                },
                listViewControllerBuilder: { (viewModel) -> NewsListViewController in
                    r.resolve(NewsListViewController.self, argument: viewModel)!
                },
                listViewModelBuilder: {
                    r.resolve(NewsListViewModelInput.self)!
                }
            )
        }.inObjectScope(.container)
        
        container.register(NewsSplitViewController.self) { r in
            let listVC = r.resolve(NewsListViewController.self)!
            let masterNavigationController = UINavigationController(rootViewController: listVC)
            masterNavigationController.navigationBar.prefersLargeTitles = true

            let detailVC = PlaceholderViewController()
            return NewsSplitViewController(listViewController: masterNavigationController, detailViewController: detailVC)
        }.inObjectScope(.container)
        
        container.register(NewsListViewController.self) { r in
            let viewModel = r.resolve(NewsListViewModelOutput.self)!
            return r.resolve(NewsListViewController.self, argument: viewModel)!
        }.inObjectScope(.container)
        
        container.register(NewsListViewController.self) { (r, viewModel: NewsListViewModelOutput) in
            NewsListViewController(viewModel: viewModel)
        }
        container.register(NewsListViewModelOutput.self) { r in
            let newsService = r.resolve(NewsServiceProtocol.self)!
            return NewsListViewModel(newsService: newsService)
        }.inObjectScope(.container).implements(NewsListViewModelInput.self).initCompleted { (r, viewModel) in
            (viewModel as! NewsListViewModel).coordinator = r.resolve(NewsViewCoordinator.self)
        }
    }
}
