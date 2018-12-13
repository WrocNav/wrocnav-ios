//
//  SearchViewController.swift
//  WrocNav
//
//  Created by Kacper Raczy on 12.12.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit

fileprivate let kSearchLocationSection = 0
fileprivate let kSearchResultsSection = 1

class SearchViewController: UIViewController {
    
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var resultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    // MARK: UI setup
    
    func setUpTableView() {
        resultTableView.dataSource = self
        resultTableView.delegate = self
        resultTableView.tableFooterView = UIView()
        resultTableView.separatorColor = UIColor.hexStringToUIColor(hex: "#e5e5e5")
        let nib = UINib(nibName: "StationTableViewCell", bundle: nil)
        resultTableView.register(nib, forCellReuseIdentifier: "stationCell")
    }
    
    func sectionHeaderLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40.0))
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = UIColor.gray
        label.textAlignment = .left
        
        return label
    }
    
    // MARK: Actions

    @IBAction func swapEndpoints(_ sender: Any) {
        
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == kSearchLocationSection {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath) as! StationTableViewCell
        if indexPath.section == kSearchLocationSection {
            cell.iconImageView.image = UIImage(named: "location")
            cell.nameLabel.text = "Your location"
            cell.descriptionLabel.text = "Wrocław"
        } else {
            cell.iconImageView.image = UIImage(named: "bus")
            cell.nameLabel.text = "Przystanek 1"
            cell.descriptionLabel.text = "Station - Lines: 1, 2, 3"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == kSearchResultsSection {
            return "Results"
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == kSearchResultsSection {
            let parentView = UIView()
            let label = sectionHeaderLabel()
            parentView.addSubview(label)
            label.text = self.tableView(tableView, titleForHeaderInSection: section)
            label.frame.origin.x = 8.0
            label.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin]
            label.sizeToFit()
            
            return parentView
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}
