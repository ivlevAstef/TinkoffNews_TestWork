//
//  ShortSqueezeOfNews.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 14/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

import Foundation

struct ShortSqueezeOfNews {
  let id: String /// ну он в api строковый какбы...
  //let name: String не нужное поле
  let text: String // приходит с html форматом. к сожалению если сразуже парсить будет очень долго
  let publicationDate: Date
  //let bankInfoTypeId: Int не нужное поле, мне кажется должно быть enum
}
