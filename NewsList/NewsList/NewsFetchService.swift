//
//  NewsFetchService.swift
//  NewsList
//
//  Created by Alex Ivashko on 23.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import Alamofire
import CoreData
import Foundation
import SwiftyXMLParser
import SwiftSoup

struct NewsItem {
    let title: String
    let link: String
    let description: String
    let publicationDate: Date
}

enum NewsFetchServiceError: Error {
    case noData
    
    case invalidXML
    
    case save
}

protocol NewsFetchServiceProtocol {
    func getSortedNewsList(from address: String, completion: @escaping((Result<[NewsItem], NewsFetchServiceError>) -> Void))
}

final class NewsFetchService {
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "NewsList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

}

extension NewsFetchService: NewsFetchServiceProtocol {
    func getSortedNewsList(from address: String, completion: @escaping((Result<[NewsItem], NewsFetchServiceError>) -> Void)) {
        AF.request(address).response { [weak self] response in
            guard let data = response.data else {
                return completion(.failure(.noData))
            }
            guard case let .singleElement(xml) = XML.parse(data) else {
                return completion(.failure(.invalidXML))
            }
            guard let rss = xml.childElements.first, rss.name == "rss" else {
                return completion(.failure(.invalidXML))
            }
            guard let channel = rss.childElements.first, channel.name == "channel" else {
                return completion(.failure(.invalidXML))
            }
            let items = channel.childElements.filter { $0.name == "item" }
            let news = items.compactMap { (element) -> NewsItem? in
                guard let title = element.childElements.first(where: { $0.name == "title" })?.text else {
                    return nil
                }
                guard let description = element.childElements.first(where: { $0.name == "description"})?.text else {
                    return nil
                }
                guard let parsedDescription = try? SwiftSoup.parseBodyFragment(description).text() else {
                    return nil
                }
                guard let dateString = element.childElements.first(where: { $0.name == "pubDate" })?.text else {
                    return nil
                }
                let dateFormatter = DateFormatter.defaultFormatter
                guard let date = dateFormatter.date(from: dateString) else {
                    return nil
                }
                guard let link = element.childElements.first(where: { $0.name == "link"})?.text else {
                    return nil
                }
                return NewsItem(title: title, link: link, description: parsedDescription, publicationDate: date)
            }
            self?.persistentContainer.performBackgroundTask { context in
                news.forEach {
                    let news = NSEntityDescription.insertNewObject(forEntityName: "News", into: context) as! News
                    news.desc = $0.description
                    news.link = $0.link
                    news.pubDate = $0.publicationDate
                    news.title = $0.title
                }
                do {
                    if context.hasChanges {
                        try context.save()
                    }
                    completion(.success(news))
                } catch {
                    completion(.failure(.save))
                }
            }
        }
    }
}
