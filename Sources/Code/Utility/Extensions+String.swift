//
//  Extensions+String.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 19/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

import Foundation

extension String {
  var removeHtml: String {
    // честно спер из инета. В принципе есть спец. либы которые делают по факту тоже самое
    let withoutTags = self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    return withoutTags.replacingOccurrences(of: "&[^;]+;", with: " ", options: .regularExpression, range: nil)
  }
  
  /* такой способ очень медленный
  var removeHtml: String {
    guard let data = self.data(using: .utf8) else {
      log(level: .warning, msg: "Can not encode html text to data.")
      log(level: .verbose, msg: "\(self)")
      return self
    }
    
    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
      .documentType: NSAttributedString.DocumentType.html,
      .characterEncoding: String.Encoding.utf8.rawValue
    ]
    
    guard let attrString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
      log(level: .warning, msg: "Can not decode html data to string.")
      log(level: .verbose, msg: "\(self)")
      return self
    }
    
    return attrString.string
  }
 */
}
