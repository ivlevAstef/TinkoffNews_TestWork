//
//  NewsFeedViewController.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 14/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

import UIKit

enum NewsFeedError: Error {
  case emptyResult
}

protocol NewsFeedDataProvider {
  /// download all news, or throw error
  ///
  /// - Throws: NewsFeedError.*
  func downloadNews() throws
  
  /// returns all news from DB, or throw error.
  ///
  /// - Returns: all news
  /// - Throws: CoreData errors
  func fetchNews() throws -> [ShortSqueezeOfNews]
}

/// может быть в вайперах там всякие презенторы нужны, да еще и модели разные, но это ведь тестовое задание - смысл прокидывать через 100 классов одно и тоже
final class NewsFeedViewController: UITableViewController {
  internal var dataProvider: NewsFeedDataProvider!
  internal var notificationController: NotificationController!
  
  private var newsList: [ShortSqueezeOfNews] = []
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // DI нет, ничего нет, делать с помощью xib без storyboard лень (чтобы в init передавать)
    Router.shared.inject(into: self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchNews()
  }
  
  @IBAction private func refresh(_ sender: Any) {
    fetchNews()
  }
}

extension NewsFeedViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return newsList.count
  }
  
  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = (tableView.dequeueReusableCell(withIdentifier: NewsFeedCell.IDENTIFIER, for: indexPath) as! NewsFeedCell)
    
    /// слегка не безопасный код, но я гарантирую, что не будет падать :)
    let news = newsList[indexPath.row]
    cell.setup(date: news.publicationDate, text: news.text)
    
    return cell
  }
  
  /// Еслибы я не использовал UITableViewAutomaticDimension то надо было код настройки писать тут :)
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let newsId = newsList[indexPath.row].id
    
    // А кто говорил, что sender-а можно использовать только как отправителя :D
    performSegue(withIdentifier: "showNewsDetails", sender: newsId)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailsViewController = segue.destination as? NewsDetalsViewController,
       let newsId = sender as? NewsID {
      detailsViewController.postInit(newsId)
    }
  }
}


extension NewsFeedViewController {
  fileprivate func fetchNews() {
    refreshControl?.beginRefreshing()
    /// Утечки - не, не слышал :) Ктомуже рано или поздно поток умрет, и ссылки вместе с ним
    DispatchQueue.global(qos: .utility).async {
      defer { DispatchQueue.main.async { self.refreshControl?.endRefreshing() } }
      do {
        try self.dataProvider.downloadNews()
      } catch {
        self.showError(error)
      }
      
      do {
        let newsList = try self.dataProvider.fetchNews()
        self.showNews(newsList)
      } catch {
        log(level: .error, msg: "db error: \(error)")
      }
    }
  }
  
  private func showNews(_ newsList: [ShortSqueezeOfNews]) {
    DispatchQueue.main.async {
      /// тут особо крутые ребята пишут диффер, и на основании диффа анимации. Но так как использовать ничего нельзя, а написать такой код это задача на месяц, то тут крутых спец эффектов не будет :)
      self.newsList = newsList
      self.tableView.reloadData()
    }
  }
  
  /// Полный механизм обработки ошибок писать долго
  /// поэтому забьем на то, что часть общих ошибок будет дублироваться - пускай будет фишкой :D
  private func showError(_ error: Error) {
    log(level: .error, msg: "show error: \(error)")
    
    let errorOfString: String
    switch error {
    case (is TinkoffRequestError):
      errorOfString = Localization.NewsFeed.Error.noLoadNewsFeed +
        Localization.TinkoffRequest.Error.localize(error: error as! TinkoffRequestError)
      
    case NewsFeedError.emptyResult:
      // ну эту ошибку можно и по другому обработать - вставить экран заглушку
      errorOfString = Localization.NewsFeed.Error.emptyResult
    default:
      errorOfString = Localization.NewsFeed.Error.noLoadNewsFeed
    }
    
    /// быстрое решение, чтобы обеспечить возврат refreshControl... на удивление, пользоваться так удобней даже
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
      self.notificationController.showError(text: errorOfString)
    }
  }
}
