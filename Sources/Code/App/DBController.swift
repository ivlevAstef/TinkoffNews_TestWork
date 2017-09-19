//
//  DBController.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 19/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

import CoreData

protocol DBController: class {
  /// Вообще в идеале тут надо было отвязаться от CoreData и запилить свою обертку... но чегото мне показалось это перебор для тестового задания
  func transaction(_ closure: (_ context: NSManagedObjectContext) throws ->()) throws
  
  func transaction<T>(_ closure: (_ context: NSManagedObjectContext) throws -> T) throws -> T
}

class DBControllerImpl: DBController {
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "TinkoffNews_TestWork")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        log(level: .error, msg: "Unresolved error \(error), \(error.userInfo)")
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  func transaction(_ closure: (_ context: NSManagedObjectContext) throws -> ()) throws {
    let context = persistentContainer.newBackgroundContext()
    try closure(context)
    
    if context.hasChanges {
      try context.save()
    }
  }
  
  func transaction<T>(_ closure: (_ context: NSManagedObjectContext) throws -> T) throws -> T {
    let context = persistentContainer.newBackgroundContext()
    return try closure(context)
  }
}


/// Лень выносить в отдельный файл

extension DBShortSqueezeOfNews {
  static let NAME: String = "\(DBShortSqueezeOfNews.self)"
}

extension DBNews {
  static let NAME: String = "\(DBNews.self)"
}
