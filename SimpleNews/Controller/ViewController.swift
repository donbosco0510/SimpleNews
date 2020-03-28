//
//  ViewController.swift
//  SimpleNews
//
//  Created by okky pribadi on 28/03/20.
//  Copyright © 2020 okky pribadi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var categories: [Category] = []
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    
    func initialSetup() {
        categories = [.general, .business, .entertainment, .health, .science, .sports, .technology]
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.separatorStyle = .none
    }
}


extension ViewController: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")!
        cell.textLabel?.text = categories[indexPath.row].rawValue
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .blue
        return cell
    }
    
    
}
