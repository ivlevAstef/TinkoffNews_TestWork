//
//  NewsFeedCell.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 14/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

import UIKit

final class NewsFeedCell: UITableViewCell {
  static let IDENTIFIER = "NewsFeedCell"
  
  @IBOutlet private var dateLbl: UILabel!
  @IBOutlet private var textLbl: UILabel!
  
  func setup(date: Date, text: String) {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm dd/mm/yyyy"
    
    self.dateLbl.text = formatter.string(from: date)
    self.textLbl.text = text
  }
}
