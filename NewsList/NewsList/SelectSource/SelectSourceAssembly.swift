//
//  SelectSourceAssembly.swift
//  NewsList
//
//  Created by Alex Ivashko on 26.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import Swinject
import UIKit

final class SelectSourceAssembly: Swinject.Assembly {
    func assemble(container: Container) {
        container.register(SelectSourceCoordinator.self) { (r) in
            let splitVC = r.resolve(NewsSplitViewController.self)!
            return SelectSourceCoordinator(splitViewController: splitVC)
        }.inObjectScope(.container)
        
        container.register(SelectSourceViewController.self) { r in
            let viewModel = r.resolve(SelectSourceViewModelProtocol.self)!
            return SelectSourceViewController(viewModel: viewModel)
        }
        
        container.register(SelectSourceViewModelProtocol.self) { r in
            let sourceService = r.resolve(SourceServiceProtocol.self)!
            return SelectSourceViewModel(sourceService: sourceService)
        }.initCompleted { (r, viewModel) in
            let coordinator = r.resolve(SelectSourceCoordinator.self)!
            (viewModel as! SelectSourceViewModel).coordinator = coordinator
        }
    }
}
