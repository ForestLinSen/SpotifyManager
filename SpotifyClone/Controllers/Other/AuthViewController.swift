//
//  AuthViewController.swift
//  SpotifyClone
//
//  Created by Sen Lin on 11/2/2022.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    
    
    private let webView: WKWebView = {
        // prefs and config
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    var completionHandler: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        print("Debug: auth url: \(AuthManager.shared.signinURL?.absoluteString)")
        guard let url = AuthManager.shared.signinURL else { return }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: {$0.name == "code"})?.value else {
            return
        }
        
        AuthManager.shared.exchangeCodeForToken(code: code) { success in
            
        }
        
        print("Debug: spotify auth code: \(code)")
    }
    
    
    

    
}
