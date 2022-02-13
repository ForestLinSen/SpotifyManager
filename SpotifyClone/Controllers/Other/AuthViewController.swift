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
        
        exchangeCodeForToken(code: code) { success in
            
        }
        
        print("Debug: spotify auth code: \(code)")
    }
    
    /// Get token
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)){
        
        guard let url = URL(string: K.tokenAPIURL) else { return }
        
        var components = URLComponents()
        
        // Each URLQueryItem represents a single key-value pair
        // https://developer.spotify.com/documentation/general/guides/authorization/code-flow/
        // grant_type, code, redirect_uri
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: K.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = "\(K.clientID):\(K.clientSecret)"
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Debug: cannot get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print("Debug: json data: \(json)")
            }catch{
                print("Debug: error serialization \(error.localizedDescription)")
                completion(false)
            }
        }
        
        task.resume()
    }
    
    public func refreshToken(){}
    
    public func cacheToken(){}
    
}
