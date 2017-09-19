//
//  News.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 19/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

import Foundation

typealias NewsID = String /// ну он в api строковый какбы...

struct News {
  let id: NewsID
  let title: String
  let textOfHtml: String
  let publicationDate: Date
}
