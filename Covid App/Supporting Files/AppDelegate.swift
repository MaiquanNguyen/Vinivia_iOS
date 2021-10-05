//
//  AppDelegate.swift
//  Covid App
//
//  Created by Baboon on 03/10/2021.
//

import UIKit
import CovidCertificateSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window?.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        CovidCertificateSDK.initialize(environment: .dev, apiKey: "b4b24598-1782-da40-7c8f-bce653458e21")
//        CovidCertificateSDK.initialize(environment: .prod, apiKey: "ae4a8d6d-f15d-6080-91ae-013e9854f512")
        prepareScreen()
        return true
    }
    
    func prepareScreen() {
        
        let attributes = [NSAttributedString.Key.font: Font.PoppinsSemiBold(16), NSAttributedString.Key.foregroundColor: UIColor.Text]
        UINavigationBar.appearance().titleTextAttributes = attributes
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .selected)
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .focused)
        UINavigationBar.appearance().tintColor = UIColor.Text
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let loginVc = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let navi = UINavigationController(rootViewController: loginVc)
        if let _ = AppConfig.shared.getAccessToken() {
            navi.viewControllers.append(EventsListViewController(nibName: "EventsListViewController", bundle: nil))
        }
        window.rootViewController = navi
    }

}

