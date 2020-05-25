//
//  NewsService.swift
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


enum NewsFetchServiceError: Error {
    case noData
    
    case invalidXML
    
    case save
    
    case coreDataFetch
}

protocol NewsServiceProtocol {
    func getSortedNewsList(from address: String, completion: @escaping((Result<[NewsItem], NewsFetchServiceError>) -> Void))
    
    func markNewsAsReaded(_ news: NewsItem)
}

final class NewsService {
    // MARK: - Private variables
    private let coreDataService: CoreDataServiceProtocol
    
    // MARK: - Initializers
    init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
    }
}

// MARK: - Private Functions
extension NewsService {
    private func getXMLItems(from response: AFDataResponse<Data?>) -> Result<[XML.Element], NewsFetchServiceError> {
        guard let data = response.data else {
            return .failure(.noData)
        }
        guard case let .singleElement(xml) = XML.parse(data) else {
            return .failure(.invalidXML)
        }
        guard let rss = xml.childElements.first, rss.name == "rss" else {
            return .failure(.invalidXML)
        }
        guard let channel = rss.childElements.first, channel.name == "channel" else {
            return .failure(.invalidXML)
        }
        let items = channel.childElements.filter { $0.name == "item" }
        return .success(items)
    }
    
    private func parse(xmlItems items: [XML.Element]) -> [NewsItem] {
        return items.compactMap { element -> NewsItem? in
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
            return NewsItem(title: title, link: link, description: parsedDescription, publicationDate: date, isReaded: false)
        }
    }
}

// MARK: - Protocol Conformance
// MARK: - NewsServiceProtocol
extension NewsService: NewsServiceProtocol {
    func getSortedNewsList(from address: String, completion: @escaping ((Result<[NewsItem], NewsFetchServiceError>) -> Void)) {
        AF.request(address).response { [weak self] response in
            guard let self = self else {
                return
            }
            let xmlItemsResult = self.getXMLItems(from: response)
            switch xmlItemsResult {
            case let .success(items):
                let newsItemsFromXML = self.parse(xmlItems: items)
                self.coreDataService.performBackgroundTask { context in
                    newsItemsFromXML.forEach {
                        let fetchRequest = NSFetchRequest<News>(entityName: "News")
                        fetchRequest.predicate = NSPredicate(format: "link == %@", $0.link)
                        guard let count = try? context.count(for: fetchRequest), count == 0 else {
                            return
                        }
                        guard let news = NSEntityDescription.insertNewObject(forEntityName: "News", into: context) as? News else {
                            return
                        }
                        news.desc = $0.description
                        news.link = $0.link
                        news.pubDate = $0.publicationDate
                        news.title = $0.title
                    }
                    do {
                        if context.hasChanges {
                            try context.save()
                        }
                        do {
                            let fetchRequest = NSFetchRequest<News>(entityName: "News")
                            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \News.pubDate, ascending: false)];
                            let result = try context.fetch(fetchRequest)
                            let newsListItems: [NewsItem] = result.compactMap {
                                guard let title = $0.title, let link = $0.link, let description = $0.desc, let publicationDate = $0.pubDate else {
                                    return nil
                                }
                                return NewsItem(title: title, link: link, description: description, publicationDate: publicationDate, isReaded: $0.isReaded)
                            }
                            completion(.success(newsListItems))
                        } catch {
                            completion(.failure(.coreDataFetch))
                        }
                    } catch {
                        completion(.failure(.save))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func markNewsAsReaded(_ news: NewsItem) {
        self.coreDataService.performBackgroundTask { context in
            let fetchRequest = NSFetchRequest<News>(entityName: "News")
            fetchRequest.predicate = NSPredicate(format: "link == %@", news.link)
            guard let result = try? context.fetch(fetchRequest), result.count == 1, let news = result.first else {
                return
            }
            news.isReaded = true
            if context.hasChanges {
                try? context.save()
            }
        }
    }
}
