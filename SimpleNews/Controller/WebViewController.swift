//
//  WebViewController.swift
//  SimpleNews
//
//  Created by okky pribadi on 28/03/20.
//  Copyright © 2020 okky pribadi. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController,WKUIDelegate {
    @IBOutlet weak var webView: WKWebView!
    var articleURL: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        if articleURL != nil
        {
           self.loadURL(url: articleURL!)
        }
    }
    
    func loadURL(url: URL) {
        webView.load(URLRequest(url: url))
    }

}
