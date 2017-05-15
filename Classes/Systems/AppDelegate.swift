//
//  AppDelegate.swift
//  Freetime
//
//  Created by Ryan Nystrom on 4/30/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GithubSessionListener {

    var window: UIWindow?
    let session = GithubSession()
    var showingLogin = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        session.addListener(listener: self)
        resetRootViewController()
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        showLogin()
    }

    // MARK: Private API

    private func showLogin(animated: Bool = false) {
        guard showingLogin == false,
            session.authorization == nil,
            let nav = UIStoryboard(
                name: "GithubLogin", 
                bundle: Bundle(for: AppDelegate.self))
                .instantiateInitialViewController() as? UINavigationController,
            let login = nav.viewControllers.first as? LoginViewController
            else { return }
        showingLogin = true
        login.session = session
        window?.rootViewController?.present(nav, animated: animated)
    }

    private func hideLogin(animated: Bool = false) {
        showingLogin = false
        window?.rootViewController?.presentedViewController?.dismiss(animated: animated)
        resetRootViewController()
    }

    private func resetRootViewController() {
        if let nav = window?.rootViewController as? UINavigationController {
            let notifications = NotificationsViewController(session: session)
            nav.viewControllers = [notifications]
        }
    }

    // MARK: GithubSessionListener

    func didAdd(session: GithubSession, authorization: Authorization) {
        hideLogin(animated: true)
    }

    func didRemove(session: GithubSession, authorization: Authorization) {
        showLogin(animated: true)
    }
    
}
