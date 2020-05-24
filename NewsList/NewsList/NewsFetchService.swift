//
//  NewsFetchService.swift
//  NewsList
//
//  Created by Alex Ivashko on 23.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyXMLParser

struct NewsListItem {
    let title: String
    let publicationDate: Date
}

enum NewsFetchServiceError: Error {
    case noData
    
    case invalidXML
}

protocol NewsFetchServiceProtocol {
    func getSortedNewsList(from address: String, completion: @escaping((Result<[NewsListItem], NewsFetchServiceError>) -> Void))
}

final class NewsFetchService {
    
}

extension NewsFetchService: NewsFetchServiceProtocol {
    func getSortedNewsList(from address: String, completion: @escaping((Result<[NewsListItem], NewsFetchServiceError>) -> Void)) {
        AF.request(address).response { response in
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
            let news = items.compactMap { (element) -> NewsListItem? in
                guard let title = element.childElements.first(where: { $0.name == "title" })?.text else {
                    return nil
                }
                guard let dateString = element.childElements.first(where: { $0.name == "pubDate" })?.text else {
                    return nil
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "E, dd MMM yyyy H:mm:ss Z"
                guard let date = dateFormatter.date(from: dateString) else {
                    return nil
                }
                return NewsListItem(title: title, publicationDate: date)
            }
            completion(.success(news))
        }
    }
}