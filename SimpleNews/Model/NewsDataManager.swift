//
//  NewsDataManager.swift
//  SimpleNews
//
//  Created by okky pribadi on 28/03/20.
//  Copyright © 2020 okky pribadi. All rights reserved.
//


import UIKit

protocol ArticleDataDelegate {
    func didGetArticleData(articleData: [Article])
    func didFailWithError(error: Error)
}

protocol SourceDataDelegate {
    func didGetSourceData(sourceData: [Source])
    func didFailWithError(error: Error)
}

class NewsDataManager {
    
    var articleDelegate: ArticleDataDelegate?
    var sourceDelegate: SourceDataDelegate?
    
    func fetchSourceList(category: Category, sender: Any) {
        let urlString = "\(Constants.shared.baseURL)sources?apiKey=\(Constants.shared.apiKey)&category=\(category.rawValue)"
        performRequest(with: urlString, delegate: sender)
    }
    
    func fetchArticles(sourceId: String, sender: Any) {
        print("Fetch articles")
        let urlString = "\(Constants.shared.baseURL)everything?sources=\(sourceId)&apiKey=\(Constants.shared.apiKey)"
        performRequest(with: urlString, delegate: self)
    }
    
    func performRequest(with urlString: String, delegate: Any) {
        print("Perform Request")
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Data Task Error")
                    if let delegate = self.sourceDelegate {
                        delegate.didFailWithError(error: error!)
                    } else if let delegate = self.articleDelegate {
                        delegate.didFailWithError(error: error!)
                    }
                    return
                }
                if let safeData = data {
                    print("Perform request - safeData")
                    if let delegate = self.sourceDelegate {
                        print("delegateSourceData")
                        if let sourcesData = self.parseJSONSourcesData(safeData, delegate: delegate) {
                            delegate.didGetSourceData(sourceData: sourcesData)
                        }
                    }
                    print ("Perform request - before articleDataDelegate")
                    if let delegate = self.articleDelegate {
                        print("delegate ArticleData")
                        if let articleData = self.parseJSONArticleData(safeData, delegate: delegate) {
                            delegate.didGetArticleData(articleData: articleData)
                        }
                    }
                }
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
        print("ParseJSONArticleData")
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(RawArticlesData.self, from: articleData)
            return decodedData.articles
        } catch {
            print("Parsing Error")
            delegate.didFailWithError(error: error)
            return nil
        }
    }
    
    func downloadImage(from url: URL, imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }.resume()
    }
}

