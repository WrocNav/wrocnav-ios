//
//  MainNavigationController.swift
//  WrocNav
//
//  Created by Kacper Raczy on 28.11.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import SideMenu

class MainNavigationController: UINavigationController, MenuTableViewControllerDelegate {
    
    private let menuController: MenuTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "menuTVC") as! MenuTableViewController
        
        return vc
    }()
    
    private let menuItems: [MenuItem] = [
        MenuItem(viewControllerId: "homeVC", title: "Map", iconName: nil),
        MenuItem(viewControllerId: "scheduleVC", title: "Schedule", iconName: nil)
    ]
    
    private var initialMenuItem: MenuItem {
        return menuItems[0]
    }
    
    private var viewControllerDict: [String: UIViewController] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuController.menuItems = menuItems
        menuController.delegate = self
        setUpSideMenu()
        setUpInitialController()
    }
    
    private func setUpSideMenu() {
        let manager = SideMenuManager.default
        let sideMenuController = UISideMenuNavigationController(rootViewController: menuController)
        manager.menuLeftNavigationController = sideMenuController
        manager.menuAddScreenEdgePanGesturesToPresent(toView: self.view, forMenu: UIRectEdge.left)
        manager.menuAnimationTransformScaleFactor = 1.0
        manager.menuPresentMode = .menuSlideIn
        manager.menuFadeStatusBar = false
    }
    
    func setUpInitialController() {
        let vc = getViewController(id: initialMenuItem.viewControllerId)
        self.setViewControllers([vc], animated: false)
    }
    
    private func getViewController(id: String) -> UIViewController {
        if viewControllerDict[id] == nil {
            viewControllerDict[id] = instantiateViewController(id: id)
        }
        
        return viewControllerDict[id]!
    }
    
    private func instantiateViewController(id: String) -> UIViewController {
        var vc: UIViewController!
        switch id {
        case "homeVC":
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            vc = storyboard.instantiateViewController(withIdentifier: id)
        default:
            log.warning("No such view controller with id: \(id), creating empty WNViewController")
            vc = WNViewController()
            vc.view.backgroundColor = UIColor.white
        }
        
        return vc
    }
    
    // MARK: MenuTableViewControllerDelegate
    
    func menu(_ menuVC: MenuTableViewController, didSelectItem item: MenuItem) {
        let vc = getViewController(id: item.viewControllerId)
        self.setViewControllers([vc], animated: false)
        self.dismiss(animated: true, completion: nil)
    }
 
}
