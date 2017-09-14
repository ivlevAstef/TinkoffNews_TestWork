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
     fatalError("Not Implemented")
  }
}
