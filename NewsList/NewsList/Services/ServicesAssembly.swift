//
//  ServicesAssembly.swift
//  NewsList
//
//  Created by Alex Ivashko on 26.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import Swinject

final class ServicesAssembly: Swinject.Assembly {
    func assemble(container: Container) {
        container.register(NewsServiceProtocol.self) { r in
            let coreDataService = r.resolve(CoreDataServiceProtocol.self)!
            return NewsService(coreDataService: coreDataService)
        }
        container.register(SourceServiceProtocol.self) { r in
            let coreDataService = r.resolve(CoreDataServiceProtocol.self)!
            return SourceService(coreDataService: coreDataService)
        }
        container.register(CoreDataServiceProtocol.self) { _ in
            CoreDataService()
        }.inObjectScope(.container)
    }
}
