//
//  Router.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 14/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

import UIKit

final class Router {
  static let shared: Router = Router()
  
  init() {
  }
  
  func inject(into vc: NewsFeedViewController) {
    vc.dataProvider = NewsFeedInteractor()
    vc.notificationController = NotificationController(rootViewController: vc)
  }
  
  func inject(into vc: NewsDetalsViewController) {
    
  }
}
