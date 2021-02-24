//
//  SplashViewController.swift
//  HW6
//
//  Created by Aliona Starunska on 24.02.2021.
//

import UIKit

class SplashViewController: UIViewController {
    
    private let keychainService = DefaultKeychainService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if keychainService.fetchToken() == nil {
            showLogin()
        } else {
            showImages()
        }
    }
    
    func showLogin() {
        guard let viewController = UIStoryboard(name: String(describing: LoginViewController.self),
                                                bundle: Bundle.main).instantiateInitialViewController() as? LoginViewController else {
            return
        }
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
    }
    
    func showImages() {
        guard let viewController = UIStoryboard(name: String(describing: ImagesViewController.self),
                                                bundle: Bundle.main).instantiateInitialViewController() as? ImagesViewController else {
            return
        }
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
    }
}
