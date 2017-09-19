//
//  NewsDetailsViewController.swift
//  TinkoffNews_TestWork
//
//  Created by Alexander Ivlev on 14/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

import UIKit

enum NewsDetailsError: Error {
  case notFound
}

protocol NewsDetailsProvider {
  /// download news details, or throw error
  ///
  /// - Throws: NewsDetailsError.*
  func downloadNewsDetails(for id: NewsID) throws
  
  /// returns news details from DB, or throw error.
  ///
  /// - Returns: all news
  /// - Throws: CoreData errors
  func fetchNewsDetails(for id: NewsID) throws -> News
}


final class NewsDetalsViewController: UIViewController {
  internal var dataProvider: NewsDetailsProvider!
  internal var notificationController: NotificationController!
  
  fileprivate var newsId: NewsID!
  
  @IBOutlet private var activityView: UIView!
  
  /// В идеале это надо было выделить в отдельную вью...
  @IBOutlet private var dateLbl: UILabel!
  @IBOutlet private var titleLbl: UILabel!
  @IBOutlet private var textView: UITextView!
  
  func postInit(_ newsId: NewsID) {
    self.newsId = newsId // ну а как его еще передать, без Presenter и с наличием storyboard :)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // DI нет, ничего нет, делать с помощью xib без storyboard лень (чтобы в init передавать)
    Router.shared.inject(into: self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchNews()
  }
}


extension NewsDetalsViewController {
  fileprivate func fetchNews() {
    activityView.isHidden = false
    
    /// Утечки - не, не слышал :) Ктомуже рано или поздно поток умрет, и ссылки вместе с ним
    DispatchQueue.global(qos: .utility).async { [newsId = newsId!] in
      defer { DispatchQueue.main.async { self.activityView.isHidden = true } }
      do {
        try self.dataProvider.downloadNewsDetails(for: newsId)
      } catch {
        self.showError(error)
      }
      
      do {
        let news = try self.dataProvider.fetchNewsDetails(for: newsId)
        self.showNews(news)
      } catch {
        log(level: .error, msg: "db error: \(error)")
      }
    }
  }
  
  private func showNews(_ news: News) {
    DispatchQueue.main.async {
      /// Вначале сделал не во вью, потом поленился вставлять еще в одну
      self.dateLbl.isHidden = false
      self.titleLbl.isHidden = false
      self.textView.isHidden = false
      
      let formatter = DateFormatter()
      formatter.dateFormat = "HH:mm dd/mm/yyyy"
      
      self.dateLbl.text = formatter.string(from: news.publicationDate)
      self.titleLbl.text = news.title
      
      if let attrString = self.toHtmlAttributedString(news.textOfHtml) {
        self.textView.attributedText = attrString
      } else {
        self.textView.text = news.textOfHtml.removeHtml
      }
    }
  }
  
  private func toHtmlAttributedString(_ textOfHtml: String) -> NSAttributedString? {
    guard let data = textOfHtml.data(using: .utf8) else {
      return nil
    }
    
    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
      .documentType: NSAttributedString.DocumentType.html,
      .characterEncoding: String.Encoding.utf8.rawValue
    ]
    
    guard let attrString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
      return nil
    }
    
    return attrString
  }
  
  /// Полный механизм обработки ошибок писать долго
  /// поэтому забьем на то, что часть общих ошибок будет дублироваться - пускай будет фишкой :D
  private func showError(_ error: Error) {
    log(level: .error, msg: "show error: \(error)")
    
    let errorOfString: String
    switch error {
    case (is TinkoffRequestError):
      errorOfString = Localization.NewsDetails.Error.noLoadNewsDetails +
        Localization.TinkoffRequest.Error.localize(error: error as! TinkoffRequestError)
      
    case NewsDetailsError.notFound:
      // ну эту ошибку можно и по другому обработать - вставить экран заглушку
      errorOfString = Localization.NewsDetails.Error.notFoundNews
    default:
      errorOfString = Localization.NewsDetails.Error.noLoadNewsDetails
    }
    
    /// Просто мне так больше понравилось :)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
      self.notificationController.showError(text: errorOfString)
    }
  }
}
