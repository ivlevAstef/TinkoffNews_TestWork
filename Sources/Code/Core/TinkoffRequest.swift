//
//  TinkoffRequest.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 18/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

import Foundation

/// Лень она такая... ну короче не буду я тут протоколы городить.
final class TinkoffRequest {
  private static let address = "https://api.tinkoff.ru"
  private static let version = "v1"
  private static let timeout: TimeInterval = 10
  
  private let address: URL
  
  init?(get method: String, with params: [String: Any] = [:]) {
    guard let url = URL(string: TinkoffRequest.makeAddress(get: method, with: params)) else {
      log(level: .error, msg: "Can't make address by \(method) with \(params)")
      assert(false, "Can't make address by \(method) with \(params)") // ибо это нештатная такто ситуация
      return nil
    }
    self.address = url
  }
  
  func call() throws -> Data? {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = TinkoffRequest.timeout
    
    let session = URLSession(configuration: configuration)
    
    var error: Error?
    var result: Data?
    
    let semaphore = DispatchSemaphore(value: 0)
    // В этом плане старое API мне нравилось больше - можно было синхронно записать...
    session.dataTask(with: address) { (inData, inResponse, inError) in
      result = inData
      error = inError
      semaphore.signal()
    }.resume()
    
    semaphore.wait()
    
    if let error = error {
      throw error
    }
    
    return result
  }
  
  private static func makeAddress(get method: String, with params: [String: Any]) -> String {
    let paramsOfStr = params.map{ "\($0)=\($1)" }.joined(separator: "&")
    
    return "\(address)/\(version)/\(method)?\(paramsOfStr)"
  }
}
