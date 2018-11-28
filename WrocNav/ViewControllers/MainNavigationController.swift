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
        MenuItem(viewControllerId: "mapVC", title: "Map", iconName: nil),
        MenuItem(viewControllerId: "scheduleVC", title: "Schedule", iconName: nil)
    ]
    
    private var viewControllerDict: [String: UIViewController] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuController.menuItems = menuItems
        menuController.delegate = self
        setUpSideMenu()
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
    
    private func getViewController(id: String) -> UIViewController {
        if viewControllerDict[id] == nil {
            viewControllerDict[id] = instantiateViewController(id: id)
        }
        
        return viewControllerDict[id]!
    }
    
    private func instantiateViewController(id: String) -> UIViewController {
        var vc: UIViewController!
        switch id {
        default:
            vc = WNViewController()
        }
        
        return vc
    }
    
    // MARK: MenuTableViewControllerDelegate
    
    func menu(_ menuVC: MenuTableViewController, didSelectItem item: MenuItem) {
        log.debug("Did select item with title: \(item.title)")
    }
 
}
