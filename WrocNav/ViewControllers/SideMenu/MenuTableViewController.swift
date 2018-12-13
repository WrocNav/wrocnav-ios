//
//  MenuTableViewController.swift
//  WrocNav
//
//  Created by Kacper Raczy on 28.11.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit

protocol MenuTableViewControllerDelegate: AnyObject {
    func menu(_ menuVC: MenuTableViewController, didSelectItem item: MenuItem)
}

extension MenuTableViewControllerDelegate {
    func menu(_ menuVC: MenuTableViewController, didSelectItem item: MenuItem) {}
}

class MenuTableViewController: UITableViewController {
    
    var menuItems: [MenuItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    weak var delegate: MenuTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") {
            let item = menuItems[indexPath.row]
            cell.textLabel?.text = item.title
            
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = menuItems[indexPath.row]
        delegate?.menu(self, didSelectItem: item)
    }
    
}
