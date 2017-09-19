//
//  Router.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 14/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

import UIKit

final class Router {
  static let shared = Router()
  
  private let dbController: DBController = DBControllerImpl()
  
  private init() {}
  
  func inject(into vc: NewsFeedViewController) {
    vc.dataProvider = NewsFeedInteractor(dbController: dbController)
    vc.notificationController = NotificationController(rootViewController: vc)
  }
  
  func inject(into vc: NewsDetalsViewController) {
    vc.dataProvider = NewsDetailsInteractor(dbController: dbController)
    vc.notificationController = NotificationController(rootViewController: vc)
  }
}
