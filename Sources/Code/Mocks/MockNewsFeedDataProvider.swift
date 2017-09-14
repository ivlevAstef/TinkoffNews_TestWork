//
//  MockNewsFeedDataProvider.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 14/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

import Foundation

final class MockNewsFeedDataProvider: NewsFeedDataProvider {
  func fetchNews() throws -> [ShortSqueezeOfNews] {
    return (0..<768).map{ index in
      return ShortSqueezeOfNews(
        id: index,
        text: "Какой то там текст от банков \(index)",
        publicationDate: Date()
      )
    }
  }
}


