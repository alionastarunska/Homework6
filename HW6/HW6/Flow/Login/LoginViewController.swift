//
//  LoginViewController.swift
//  HW6
//
//  Created by Aliona Starunska on 23.02.2021.
//

import UIKit
import  WebKit

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var LogInButton: UIButton!
    @IBOutlet private weak var loginWKWebView: WKWebView!
    
    private var webView = WKWebView()
    
    private var keychainService: KeychainService = DefaultKeychainService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func loginButtonAction(_ sender: UIButton) {
        githubAuthVC()
    }
    
    private func githubAuthVC() {
        // Create github Auth ViewController
        let githubVC = UIViewController()
        // Generate random identifier for the authorization
        let uuid = UUID().uuidString
        // Create WebView
        let webView = WKWebView()
        webView.navigationDelegate = self
        githubVC.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: githubVC.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: githubVC.view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: githubVC.view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: githubVC.view.trailingAnchor)
        ])
        
        let authURLFull = "https://github.com/login/oauth/authorize?client_id=" + GithubConstants.CLIENT_ID + "&scope=" + GithubConstants.SCOPE + "&redirect_uri=" + GithubConstants.REDIRECT_URI + "&state=" + uuid
        
        let urlRequest = URLRequest(url: URL(string: authURLFull)!)
        webView.load(urlRequest)
        
        // Create Navigation Controller
        let navController = UINavigationController(rootViewController: githubVC)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        githubVC.navigationItem.leftBarButtonItem = cancelButton
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshAction))
        githubVC.navigationItem.rightBarButtonItem = refreshButton
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = textAttributes
        githubVC.navigationItem.title = "github.com"
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = UIColor.white
        navController.navigationBar.barTintColor = UIColor.black
        navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.modalTransitionStyle = .coverVertical
        
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc private func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func refreshAction() {
        webView.reload()
    }
    
    private func showImages() {
        guard let viewController = UIStoryboard(name: String(describing: ImagesViewController.self),
                                      bundle: Bundle.main).instantiateInitialViewController() as? ImagesViewController else {
            return
        }
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
    }
}

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        self.requestForCallbackURL(request: navigationAction.request)
        decisionHandler(.allow)
    }
    
    func requestForCallbackURL(request: URLRequest) {
        // Get the authorization code string after the '?code=' and before '&state='
        let requestURLString = (request.url?.absoluteString)! as String
        print(requestURLString)
        if requestURLString.hasPrefix(GithubConstants.REDIRECT_URI) {
            if requestURLString.contains("code=") {
                if let range = requestURLString.range(of: "=") {
                    let githubCode = requestURLString[range.upperBound...]
                    if let range = githubCode.range(of: "&state=") {
                        let githubCodeFinal = githubCode[..<range.lowerBound]
                        githubRequestForAccessToken(authCode: String(githubCodeFinal))
                        
                        // Close GitHub Auth ViewController after getting Authorization Code
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func githubRequestForAccessToken(authCode: String) {
        let grantType = "authorization_code"
        
        let postParams = "grant_type=" + grantType + "&code=" + authCode + "&client_id=" + GithubConstants.CLIENT_ID + "&client_secret=" + GithubConstants.CLIENT_SECRET
        let postData = postParams.data(using: String.Encoding.utf8)
        let request = NSMutableURLRequest(url: URL(string: GithubConstants.TOKENURL)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { [weak self] (data, response, _) -> Void in
            guard let data = data, let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
            if statusCode == 200 {
                let results = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
                DispatchQueue.main.async {
                    if let accessToken = results?["access_token"] as? String {
                        self?.keychainService.save(token: accessToken)
                        self?.showImages()
                    }
                }
            }
        }
        task.resume()
    }
}
