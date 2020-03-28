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
        cell.nameLabel.text = sourceData![indexPath.row].name!
        cell.descriptionText.text = sourceData![indexPath.row].description!
        cell.selectionStyle = .blue
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    

}

extension SourcesViewController: SourceDataDelegate {
    func didGetSourceData(sourceData: [Source]) {
        self.sourceData = sourceData
        DispatchQueue.main.async {
            self.sourcesTableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print("Error: \(error)")
    }
}
