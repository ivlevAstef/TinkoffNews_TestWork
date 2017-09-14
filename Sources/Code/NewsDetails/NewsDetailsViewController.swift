//
//  NewsDetailsViewController.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 14/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

import UIKit

final class NewsDetalsViewController: UIViewController {
  override func awakeFromNib() {
    super.awakeFromNib()
    // DI нет, ничего нет, делать с помощью xib без storyboard лень (чтобы в init передавать)
    Router.shared.inject(into: self)
  }
}
