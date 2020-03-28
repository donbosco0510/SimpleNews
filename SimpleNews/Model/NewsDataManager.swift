//
//  NewsDataManager.swift
//  SimpleNews
//
//  Created by okky pribadi on 28/03/20.
//  Copyright © 2020 okky pribadi. All rights reserved.
//


import UIKit

protocol ArticleDataDelegate {
    func didGetArticleData(fetchedArticleData: [Article])
    func didFailWithError(error: Error)
    func setTotalResults(_ total: Int)
}

protocol SourceDataDelegate {
    func didGetSourceData(fetchedSourceData: [Source])
    func didFailWithError(error: Error)
}

class NewsDataManager {
    
    var articleDelegate: ArticleDataDelegate?
    var sourceDelegate: SourceDataDelegate?
    var isFetchInProgress: Bool = false
    static var currentArticlePage = 0
    
    func fetchSourceList(category: Category, sender: Any) {
        let urlString = "\(Constants.shared.baseURL)sources?&apiKey=\(Constants.shared.apiKey)&category=\(category.rawValue)"
        print("fetchSourceList: \(urlString)")
        if !isFetchInProgress {
            isFetchInProgress = true
            performRequest(with: urlString, delegate: sender)
        }
    }
    
    func fetchArticles(sourceId: String, sender: Any) {
        let urlString = "\(Constants.shared.baseURL)everything?sources=\(sourceId)&page=\(NewsDataManager.currentArticlePage+1)&apiKey=\(Constants.shared.apiKey)"
        print("fetchArticles: \(urlString)")
        if !isFetchInProgress {
            isFetchInProgress = true
            performRequest(with: urlString, delegate: self)
        }
    }
    
    func performRequest(with urlString: String, delegate: Any) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    if let delegate = self.sourceDelegate {
                        delegate.didFailWithError(error: error!)
                    } else if let delegate = self.articleDelegate {
                        delegate.didFailWithError(error: error!)
                    }
                    return
                }
                if let safeData = data {
                    if let delegate = self.sourceDelegate {
                        if let sourcesData = self.parseJSONSourcesData(safeData, delegate: delegate) {
                            delegate.didGetSourceData(fetchedSourceData: sourcesData)
                        }
                    }
                    if let delegate = self.articleDelegate {
                        if let articleData = self.parseJSONArticleData(safeData, delegate: delegate) {
                            NewsDataManager.currentArticlePage += 1
                            delegate.didGetArticleData(fetchedArticleData: articleData)
                        }
                    }
                }
                self.isFetchInProgress = false
            }
            task.resume()
        }
    }
    
    func parseJSONSourcesData(_ sourceData: Data, delegate: SourceDataDelegate) -> [Source]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(RawSourcesData.self, from: sourceData)
            return decodedData.sources
        } catch {
            print("Parsing Error")
            delegate.didFailWithError(error: error)
            return nil
        }
    }
    
    func parseJSONArticleData(_ articleData: Data, delegate: ArticleDataDelegate) -> [Article]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(RawArticlesData.self, from: articleData)
            delegate.setTotalResults(decodedData.totalResults)
            return decodedData.articles
        } catch {
            delegate.didFailWithError(error: error)
            return nil
        }
    }
    
    func downloadImage(from url: URL, cell: ArticlesTableViewCell) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                cell.articleImage.image = UIImage(data: data)
                cell.indicatorView.stopAnimating()
            }
        }.resume()
    }
}
