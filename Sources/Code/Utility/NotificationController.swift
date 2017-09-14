//
//  NotificationController.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 14/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

import UIKit

final class NotificationController {
  private let rootViewController: UIViewController
  
  init(rootViewController: UIViewController) {
    self.rootViewController = rootViewController
  }
  
  func showError(text: String) {
    log(level: .warning, msg: text)
    
    let alertController = UIAlertController(
      title: Localization.Notification.titleForErrors,
      message: text,
      preferredStyle: .alert
    )
    
    alertController.addAction(UIAlertAction(
      title: Localization.Notification.OK,
      style: .default,
      handler: nil
    ))
    
    rootViewController.present(alertController, animated: true, completion: nil)
  }
}
