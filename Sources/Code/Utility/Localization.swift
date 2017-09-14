//
//  Localization.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 14/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

struct Localization {
  struct NewsFeed {
    struct Error {
      private static var noLoadNewsFeed: String {
        return "Не удалось загрузить ленту новостей."
      }
      
      static var noInternet: String {
        return "\(noLoadNewsFeed) Проверьте соединение с интернетом."
      }
      
      static var invalidData: String {
        return "\(noLoadNewsFeed) На сервере ведутся технические работы, попробуйте повторить загрузку позже."
      }
      
      static var undefined: String {
        return noLoadNewsFeed
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
