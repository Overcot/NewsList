//
//  Assembly.swift
//  NewsList
//
//  Created by Alex Ivashko on 26.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import Swinject

enum Assembly {
    static var container: Container = {
        let container = Container()
        NewsAssembly().assemble(container: container)
        SelectSourceAssembly().assemble(container: container)
        ServicesAssembly().assemble(container: container)
        return container
    }()
}
