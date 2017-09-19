//
//  Localization.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 14/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

struct Localization {
  struct TinkoffRequest {
    struct Error {
      static var noInternet: String {
        return "Проверьте соединение с интернетом."
      }
      
      static var invalidData: String {
        return "На сервере ведутся технические работы, попробуйте повторить загрузку позже."
      }
      
      static var notOk: String {
        return "Попробуйте повторить загрузку позже."
      }
      
      static func localize(error: TinkoffRequestError) -> String {
        switch error {
        case .noInternet:
          return Localization.TinkoffRequest.Error.noInternet
        case .invalidData:
          return Localization.TinkoffRequest.Error.invalidData
        case .notOk:
          return Localization.TinkoffRequest.Error.notOk
        }
      }
    }
  }
  
  struct NewsFeed {
    struct Error {
      static var noLoadNewsFeed: String {
        return "Не удалось загрузить ленту новостей."
      }
      
      static var emptyResult: String {
        return "Упс... А новостей то нету."
      }
    }
  }
  
  struct NewsDetails {
    struct Error {
      static var noLoadNewsDetails: String {
        return "Не удалось загрузить новость."
      }
      
      static var notFoundNews: String {
        return "Упс... А новости то нету. Возможно она была удалена."
      }
    }
  }
  
  struct Notification {
    static var titleForErrors: String {
      return "Ошибка"
    }
    
    static var OK: String {
      return "OK"
    }
  }
}
