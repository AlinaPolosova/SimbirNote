//
//  AppDelegate.swift
//  SimbirNote
//
//  Created by Mac on 11.12.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
            let presenter = MainPresenter(view: mainVC)
            mainVC.presenter = presenter
            navigationController.setViewControllers([mainVC], animated: true)
        }
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}
