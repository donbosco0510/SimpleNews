//
//  ArticlesViewController.swift
//  SimpleNews
//
//  Created by okky pribadi on 28/03/20.
//  Copyright © 2020 okky pribadi. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController {

    @IBOutlet weak var articlesTableView: UITableView!
    
        let newsDataManager = NewsDataManager()
        var sourceId: String!
        var articlesData: [Article] = []
        var totalResults: Int = 0
        var activityIndicatorFullView: UIView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            initialSetup()
        }
        
        func initialSetup() {
            articlesTableView.delegate = self
            articlesTableView.dataSource = self
            articlesTableView.prefetchDataSource = self
            newsDataManager.articleDelegate = self
            newsDataManager.fetchArticles(sourceId: sourceId, sender: self)
            activityIndicatorFullView = LoadingIndicator(frame: view.frame)
            NewsDataManager.currentArticlePage = 0
            view.addSubview(activityIndicatorFullView)
        }
    }

    extension ArticlesViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return totalResults
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell") as! ArticlesTableViewCell
            if indexPath.row < articlesData.count {
                cell.configure(with: articlesData[indexPath.row])
            } else {
                cell.configure(with: .none)
            }
            
            cell.selectionStyle = .blue
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = indexPath.row % 2 == 0 ? .white : UIColor(red: 0, green: 0, blue: 0, alpha: Constants.shared.alternateHighlightAlpha)
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("Article Data: \(articlesData[indexPath.row].url)")
            if let articleURL = URL(string: articlesData[indexPath.row].url ?? "") {
                let webVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebView") as! WebViewController
                webVC.modalPresentationStyle = .overCurrentContext
                webVC.title = articlesData[indexPath.row].title!
                webVC.articleURL = articleURL
                tableView.deselectRow(at: indexPath, animated: true)
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.pushViewController(webVC, animated: true)
            }
        }
    }

    extension ArticlesViewController: UITableViewDataSourcePrefetching {
        func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
            for indexPath in indexPaths {
                if indexPath.row >= articlesData.count {
                    newsDataManager.fetchArticles(sourceId: sourceId, sender: self)
                }
            }
        }
    }

    extension ArticlesViewController: ArticleDataDelegate {
        func setTotalResults(_ total: Int) {
            totalResults = total
        }
        
        func didGetArticleData(fetchedArticleData: [Article]) {
            self.articlesData.append(contentsOf: fetchedArticleData)
            DispatchQueue.main.async {
                self.articlesTableView.reloadData()
                self.activityIndicatorFullView.removeFromSuperview()
            }
        }
        
        func didFailWithError(error: Error) {
            print("Error: \(error)")
        }
        
    }

