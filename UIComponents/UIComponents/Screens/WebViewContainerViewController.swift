//
//  WebViewContainerViewController.swift
//  UIComponents
//
//  Created by Semih Emre ÜNLÜ on 9.01.2022.
//

import UIKit
import WebKit

class WebViewContainerViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureWebView()
        configureActivityIndicator()
    }

    var urlString = "https://www.google.com"

    func configureWebView() {
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)

        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
//        webView.configuration = configuration
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.isLoading),
                            options: .new,
                            context: nil)
        //webView.load(urlRequest)
        loadHtml()
    }

    func configureActivityIndicator() {
        activityIndicator.style = .large
        activityIndicator.color = .red
        activityIndicator.hidesWhenStopped = true
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {

        if keyPath == "loading" {
            webView.isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }

    }

    @IBAction func reloadButtonTapped(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    @IBAction func openInSafariButtonTapped(_ sender: UIBarButtonItem) {
        if let url = webView.url {
            UIApplication.shared.open(url)
        }
    }
    
    
    @IBAction func goBackwardButtonTapped(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    
    @IBAction func goForwardButtonTapped(_ sender: UIBarButtonItem) {
        webView.goForward()
    }

    func loadHtml() {
        let html =
            """
            <!DOCTYPE html>
            <html>
                <body>
                    <h1">HTML Links</h1>
                    <p id="plink"><a href="https://www.google.com/">Visit google.com!</a></p>
                </body>
            </html>
            """
        let js =
            """
            document.getElementById("plink").style.fontFamily = "Impact,Charcoal,sans-serif";
            """
        webView.loadHTMLString(html, baseURL: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.webView.evaluateJavaScript(js, completionHandler: nil)
        }
    }

}

extension WebViewContainerViewController: WKNavigationDelegate {

}

extension WebViewContainerViewController: WKUIDelegate {

}
