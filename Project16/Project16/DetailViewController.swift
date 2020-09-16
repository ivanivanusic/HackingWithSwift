//
//  DetailViewController.swift
//  Project16
//
//  Created by Ivan Ivanušić on 16/09/2020.
//  Copyright © 2020 Ivan Ivanušić. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet var webView: WKWebView!
    var city: String?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: "https://en.wikipedia.org/wiki/\(city!)") {
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
    }

}
