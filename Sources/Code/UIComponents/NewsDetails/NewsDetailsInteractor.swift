//
//  NewsDetailsInteractor.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 20/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

import Foundation
import CoreData

final class NewsDetailsInteractor {
  private let dbController: DBController
  
  init(dbController: DBController) {
    self.dbController = dbController
  }
}

extension NewsDetailsInteractor: NewsDetailsProvider {
  func downloadNewsDetails(for id: NewsID) throws {
    guard let request = TinkoffRequest(get: "news_content", with: ["id": id]) else {
      fatalError("Hmm... I can't make request? really...")
    }
    
    let json = try request.apiCall()
    
    guard let payload: [String: Any] = json["payload"] as? [String : Any] else {
      throw TinkoffRequestError.invalidData
    }
    
    // заигнорим невалидные значения
    guard let news = News(by: payload) else {
      throw TinkoffRequestError.invalidData
    }
    
    try saveNewsDetails(news)
  }
  
  private func saveNewsDetails(_ news: News) throws {
    try dbController.transaction { dbContext in
      let entity = NSEntityDescription.entity(forEntityName: DBNews.NAME, in: dbContext)!
    
      let request: NSFetchRequest<DBNews> = DBNews.fetchRequest()
      request.predicate = NSPredicate(format: "id = \(news.id)")
      
      let currentNews = try dbContext.fetch(request)
      assert(currentNews.count <= 1, "WTF - in DB contains more news by equals id.")
      
      let dbNews = currentNews.first ?? DBNews(entity: entity, insertInto: dbContext)
      
      dbNews.id = news.id
      dbNews.title = news.title
      dbNews.text = news.textOfHtml
      dbNews.publicationDate = news.publicationDate
    }
  }
  
  func fetchNewsDetails(for id: NewsID) throws -> News {
    return try dbController.transaction{ dbContext in
      let request: NSFetchRequest<DBNews> = DBNews.fetchRequest()
      request.predicate = NSPredicate(format: "id = \(id)")
      
      let currentNews = try dbContext.fetch(request)
      assert(currentNews.count <= 1, "WTF - in DB contains more news by equals id.")
      
      guard let dbNews = currentNews.first else {
        throw NewsDetailsError.notFound
      }
      
      /// Ну возможно надо проверять, но какбы в БД стоит что они не опционалы...
      return News(
        id: dbNews.id!,
        title: dbNews.title!,
        textOfHtml: dbNews.text!,
        publicationDate: dbNews.publicationDate!
      )
    }
  }
}

fileprivate extension News {
  fileprivate init?(by dict: [String: Any]) {
    /// Ктонибудь бы мог сказать, что title содержит тоже самое, что и метод для ленты, но всеже я считаю это совпадением, и всеже продублирую код.
    guard let titleDict = dict["title"] as? [String: Any]
      , let id = titleDict["id"] as? String
      , let titleOfHtml = titleDict["text"] as? String
      , let textOfHtml = dict["content"] as? String
      , let publicDateOfDict = titleDict["publicationDate"] as? [String: Int]
      , let publicDateOfInt = publicDateOfDict["milliseconds"] else
    {
        log(level: .warning, msg: "Can not parse payload part.")
        log(level: .verbose, msg: "\(dict)")
        return nil
    }
    
    let publicDate = Date(timeIntervalSince1970: TimeInterval(publicDateOfInt) / 1000.0)
    self.init(id: id, title: titleOfHtml.removeHtml, textOfHtml: textOfHtml, publicationDate: publicDate)
  }
}
