//
//  Logger.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 14/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

import Foundation

enum LogLevel {
  case error
  case warning
  case info
  case debug
  case verbose
  
  fileprivate var logStr: String {
    switch self {
    case .error:
      return "[ERR]"
    case .warning:
      return "[WRN]"
    case .info:
      return "[INF]"
    case .debug:
      return "[DBG]"
    case .verbose:
      return "[VRB]"
    }
  }
}

func log(level: LogLevel, msg: String, file: String = #file, line: Int = #line) {
  let path = file.components(separatedBy: CharacterSet(charactersIn: "/\\"))
  let fileName = path.last ?? ""
  print("\(level.logStr) (\(fileName):\(line)): \(msg)")
}
