//
//  NewsFeedInteractor.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 14/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

import Foundation

final class NewsFeedInteractor {
}

extension NewsFeedInteractor: NewsFeedDataProvider {
  func fetchNews() throws -> [ShortSqueezeOfNews] {
    let request = TinkoffRequest(get: "news")
    
    guard let result = try request?.call() else {
      throw NewsFeedError.unknown // упростим жизнь... не буду разбираться, что именно пошло не так
    }
    
    guard let json: [String: Any] = (try? JSONSerialization.jsonObject(with: result, options: [])) as? [String : Any] else {
      throw NewsFeedError.invalidData
    }
    
    guard let resultCode = json["resultCode"] as? String, resultCode == "OK" else {
      throw NewsFeedError.notOk
    }
    
    guard let payload: [[String: Any]] = json["payload"] as? [[String : Any]] else {
      throw NewsFeedError.invalidData
    }
    
    // заигнорим невалидные значения
    let news = payload.flatMap { ShortSqueezeOfNews(by: $0) }
    
    return news
  }
}

fileprivate extension ShortSqueezeOfNews {
  fileprivate init?(by dict: [String: Any]) {
    guard let id = dict["id"] as? String
      , let _ = dict["name"] as? String
      , let textOfHtml = dict["text"] as? String
      , let publicDateOfDict = dict["publicationDate"] as? [String: Int]
      , let publicDateOfInt = publicDateOfDict["milliseconds"]
      , let _ = dict["bankInfoTypeId"] as? Int else {
        
        log(level: .warning, msg: "Can not parse payload part.")
        log(level: .verbose, msg: "\(dict)")
        return nil
    }
    
    let publicDate = Date(timeIntervalSince1970: TimeInterval(publicDateOfInt) / 1000.0)
    self.init(id: id, text: textOfHtml.removeHtml, publicationDate: publicDate)
  }
}
