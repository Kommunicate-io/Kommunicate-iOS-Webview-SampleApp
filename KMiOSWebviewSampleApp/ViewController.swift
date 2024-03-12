//
//  ViewController.swift
//  KMiOSWebviewSampleApp
//
//  Created by sathyan elangovan on 12/03/24.
//

import UIKit
import WebKit

/*
 This ViewController implementation is simplest form loading the Kommunicate Chat Widget inside the
 */
public class ViewController: UIViewController {
    var webView: WKWebView = .init()
    
    override public func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view = webView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        // https://widget.kommunicate.io/chat?appId=<Your App Id>
        guard let url = URL(string: "https://widget.kommunicate.io/chat?appId=18ae6ce9d4f469f95c9c095fb5b0bda44") else {
            print("Failed to get the url to load")
            return
        }
        webView.load(URLRequest(url: url))
    }
}

extension ViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard navigationAction.navigationType == .linkActivated else {
            decisionHandler(.allow)
            return
        }
        webView.load(navigationAction.request)
        decisionHandler(.cancel)
    }
}

// To Support some rich message clicks & its navigation, we need this delegate setup
extension ViewController : WKUIDelegate {
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let frame = navigationAction.targetFrame,
            frame.isMainFrame {
            return nil
        }
        webView.load(navigationAction.request)
        return nil
    }

}
