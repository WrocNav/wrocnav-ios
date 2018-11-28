//
//  WNViewController.swift
//  WrocNav
//
//  Created by Kacper Raczy on 28.11.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import SideMenu

@objc enum WNMenuStyle: Int {
    case dark
    case light
    
    var color: UIColor {
        switch self {
        case .dark:
            return UIColor.black
        case .light:
            return UIColor.white
        }
    }
}

@objc protocol WNMenu: AnyObject {
    @objc func revealMenu(sender: Any?)
    var buttonStyle: WNMenuStyle { get }
}

extension WNMenu where Self: UIViewController {
    
    func createMenuButton() -> UIBarButtonItem {
        let image = UIImage(named: "menu_bars")?.withRenderingMode(.alwaysTemplate)
        let barButton = UIBarButtonItem(image: image,
                                        style: .plain,
                                        target: self,
                                        action: #selector(revealMenu(sender:)))
        barButton.tintColor = buttonStyle.color
        
        return barButton
    }
    
}

class WNViewController: UIViewController, WNMenu {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = createMenuButton()
    }
    
    @objc func revealMenu(sender: Any?) {
        let manager = SideMenuManager.default
        present(manager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    var buttonStyle: WNMenuStyle {
        return .dark
    }
    
}

class WNTableViewController: UITableViewController, WNMenu {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = createMenuButton()
    }
    
    @objc func revealMenu(sender: Any?) {
        let manager = SideMenuManager.default
        if let navigationController = self.navigationController {
            navigationController.present(manager.menuLeftNavigationController!, animated: true, completion: nil)
        } else {
            log.warning("No navigation controller. Unable to present side menu.")
        }
    }
    
    var buttonStyle: WNMenuStyle {
        return .dark
    }
    
}
