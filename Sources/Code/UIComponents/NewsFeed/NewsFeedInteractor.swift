//
//  NewsFeedInteractor.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 14/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

import Foundation
import CoreData

final class NewsFeedInteractor {
  private let dbController: DBController
  
  init(dbController: DBController) {
    self.dbController = dbController
  }
}

extension NewsFeedInteractor: NewsFeedDataProvider {
  func downloadNews() throws {
    guard let request = TinkoffRequest(get: "news") else {
      fatalError("Hmm... I can't make request? really...")
    }
    
    let json = try request.apiCall()
    
    guard let payload: [[String: Any]] = json["payload"] as? [[String : Any]] else {
      throw TinkoffRequestError.invalidData
    }
    
    // заигнорим невалидные значения
    let newsList = payload.flatMap { ShortSqueezeOfNews(by: $0) }
    
    if newsList.isEmpty {
      throw NewsFeedError.emptyResult
    }
    
    try saveNews(newsList)
  }
  
  private func saveNews(_ newsList: [ShortSqueezeOfNews]) throws {
    try dbController.transaction { dbContext in
      let entity = NSEntityDescription.entity(forEntityName: DBShortSqueezeOfNews.NAME, in: dbContext)!
      
      for news in newsList {
        let request: NSFetchRequest<DBShortSqueezeOfNews> = DBShortSqueezeOfNews.fetchRequest()
        request.predicate = NSPredicate(format: "id = \(news.id)")
        
        let currentNews = try dbContext.fetch(request)
        assert(currentNews.count <= 1, "WTF - in DB contains more news by equals id.")
        
        let dbNews = currentNews.first ?? DBShortSqueezeOfNews(entity: entity, insertInto: dbContext)
        
        dbNews.id = news.id
        dbNews.text = news.text
        dbNews.publicationDate = news.publicationDate
      }
    }
  }
  
  func fetchNews() throws -> [ShortSqueezeOfNews] {
    return try dbController.transaction{ dbContext in
      let request: NSFetchRequest<DBShortSqueezeOfNews> = DBShortSqueezeOfNews.fetchRequest()
      
      return try dbContext.fetch(request).map { dbNews in
        /// Ну возможно надо проверять, но какбы в БД стоит что они не опционалы...
        ShortSqueezeOfNews(id: dbNews.id!,
                           text: dbNews.text!,
                           publicationDate: dbNews.publicationDate!)
      }
    }
  }
}

fileprivate extension ShortSqueezeOfNews {
  fileprivate init?(by dict: [String: Any]) {
    guard let id = dict["id"] as? String
      , let textOfHtml = dict["text"] as? String
      , let publicDateOfDict = dict["publicationDate"] as? [String: Int]
      , let publicDateOfInt = publicDateOfDict["milliseconds"] else
    {
        log(level: .warning, msg: "Can not parse payload part.")
        log(level: .verbose, msg: "\(dict)")
        return nil
    }
    
    let publicDate = Date(timeIntervalSince1970: TimeInterval(publicDateOfInt) / 1000.0)
    self.init(id: id, text: textOfHtml.removeHtml, publicationDate: publicDate)
  }
}

/// Зажрался - класс из 100 строчек все время мне кажется перегруженным...

