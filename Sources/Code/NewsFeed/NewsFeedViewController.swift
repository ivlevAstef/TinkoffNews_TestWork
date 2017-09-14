//
//  NewsFeedViewController.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 14/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

import UIKit

enum NewsFeedError: Error {
  case noInternet
  case invalidData
}

protocol NewsFeedDataProvider {
  /// returns all news, or throw error.
  ///
  /// - Returns: all news
  /// - Throws: NewsFeedError*
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
    return tableView.dequeueReusableCell(withIdentifier: NewsFeedCell.IDENTIFIER, for: indexPath)
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    /// слегка не безопасный код, но я гарантирую, что не будет падать :)
    let news = newsList[indexPath.row]
    (cell as! NewsFeedCell).setup(date: news.publicationDate, text: news.text)
  }
}


extension NewsFeedViewController {
  fileprivate func fetchNews() {
    refreshControl?.beginRefreshing()
    /// Утечки - не, не слышал :) Ктомуже рано или поздно поток умрет, и ссылки вместе с ним
    DispatchQueue.global(qos: .utility).async {
      defer { DispatchQueue.main.async { self.refreshControl?.endRefreshing() } }
      do {
        let newsList = try self.dataProvider.fetchNews()
        self.showNews(newsList)
      } catch {
        self.showError(error)
      }
    }
  }
  
  private func showNews(_ newsList: [ShortSqueezeOfNews]) {
    DispatchQueue.main.async {
      self.newsList = newsList
      self.tableView.reloadData()
    }
  }
  
  private func showError(_ error: Error) {
    let errorOfString: String
    switch error {
    case NewsFeedError.noInternet:
      errorOfString = Localization.NewsFeed.Error.noInternet
    case NewsFeedError.invalidData:
      errorOfString = Localization.NewsFeed.Error.invalidData
    default:
      errorOfString = Localization.NewsFeed.Error.undefined
    }
    
    DispatchQueue.main.async {
      self.notificationController.showError(text: errorOfString)
    }
  }
}
