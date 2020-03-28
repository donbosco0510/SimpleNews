//
//  SourcesViewController.swift
//  SimpleNews
//
//  Created by okky pribadi on 28/03/20.
//  Copyright © 2020 okky pribadi. All rights reserved.
//

import UIKit

class SourcesViewController: UIViewController {

    @IBOutlet weak var sourcesTableView: UITableView!

     var activityIndicatorFullView: UIView!
       
       let newsDataManager = NewsDataManager()
       var sourceData: [Source]?
       var selectedCategory: Category!
       
       override func viewDidLoad() {
           super.viewDidLoad()
           initialSetup()
       }
       
       func initialSetup() {
           sourcesTableView.delegate = self
           sourcesTableView.dataSource = self
           newsDataManager.sourceDelegate = self
           newsDataManager.fetchSourceList(category: selectedCategory, sender: self)
           activityIndicatorFullView = LoadingIndicator(frame: view.frame)
           view.addSubview(activityIndicatorFullView)
       }

}

extension SourcesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sourceData != nil {
            return sourceData!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sourcesCell") as! SourcesTableViewCell
        cell.configure(with: sourceData![indexPath.row])
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = indexPath.row % 2 == 0 ? .white : UIColor(red: 0, green: 0, blue: 0, alpha: Constants.shared.alternateHighlightAlpha)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "articlesView") as! ArticlesViewController
        destinationVC.modalPresentationStyle = .overCurrentContext
        destinationVC.title = sourceData![indexPath.row].name
        destinationVC.sourceId = sourceData![indexPath.row].id
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension SourcesViewController: SourceDataDelegate {
    func didGetSourceData(fetchedSourceData: [Source]) {
        self.sourceData = fetchedSourceData
        DispatchQueue.main.async {
            self.sourcesTableView.reloadData()
            self.activityIndicatorFullView?.removeFromSuperview()
        }
    }
    
    func didFailWithError(error: Error) {
        print("Error: \(error)")
    }
}
