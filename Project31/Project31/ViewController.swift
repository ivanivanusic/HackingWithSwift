//
//  ViewController.swift
//  Project31
//
//  Created by Ivan Ivanušić on 30.01.2021..
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var adressBar: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    weak var activeWebView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultTitle()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [add, delete]
        adressBar.delegate = self
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
    }
    
    func updateUI(for webView: WKWebView) {
        title = webView.title
        adressBar.text = webView.url?.absoluteString ?? ""
    }
    
    func setDefaultTitle() {
        title = "Multibrowser"
    }
    
    func selectWebView(_ webView: WKWebView) {
        for view in stackView.arrangedSubviews {
            view.layer.borderWidth = 0
        }

        activeWebView = webView
        webView.layer.borderWidth = 3
        updateUI(for: webView)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView == activeWebView {
            updateUI(for: webView)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let webView = activeWebView, var address = adressBar.text {
            if !address.hasPrefix("https://") {
                address = "https://" + address
            }
            if let url = URL(string: address) {
                webView.load(URLRequest(url: url))
            }
        }

        textField.resignFirstResponder()
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func addWebView() {
        let webView = WKWebView()
        webView.navigationDelegate = self
        
        stackView.addArrangedSubview(webView)
        
        let url = URL(string: "https://www.hackingwithswift.com")!
        webView.load(URLRequest(url: url))
        
        webView.layer.borderColor = UIColor.blue.cgColor
        selectWebView(webView)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
    }
    
    @objc func deleteWebView() {
        // safely unwrap our webview
        if let webView = activeWebView {
            if let index = stackView.arrangedSubviews.firstIndex(of: webView) {
                // We found the webview – remove it from the stack view and destroy it
                webView.removeFromSuperview()

                if stackView.arrangedSubviews.count == 0 {
                    // go back to our default UI
                    setDefaultTitle()
                } else {
                    // convert the Index value into an integer
                    var currentIndex = Int(index)

                    // if that was the last web view in the stack, go back one
                    if currentIndex == stackView.arrangedSubviews.count {
                        currentIndex = stackView.arrangedSubviews.count - 1
                    }

                    // find the web view at the new index and select it
                    if let newSelectedWebView = stackView.arrangedSubviews[currentIndex] as? WKWebView {
                        selectWebView(newSelectedWebView)
                    }
                }
            }
        }
    }
    
    @objc func webViewTapped(_ recognizer: UITapGestureRecognizer) {
        if let selectedWebView = recognizer.view as? WKWebView {
            selectWebView(selectedWebView)
        }
    }

}

