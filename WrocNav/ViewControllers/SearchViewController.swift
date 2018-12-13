//
//  SearchViewController.swift
//  WrocNav
//
//  Created by Kacper Raczy on 12.12.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import RxSwift

fileprivate let kSearchLocationSection = 0
fileprivate let kSearchResultsSection = 1

class SearchViewController: UIViewController {
    
    private var stations: [Station] = [] {
        didSet {
            resultTableView.reloadData()
        }
    }
    private var searchEngine: SearchEngine<Station>?
    private let dataService: DataService = DataService.shared
    private let disposeBag: DisposeBag = DisposeBag()
    var sourceLocation: Location?
    var destinationLocation: Location?
    
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var resultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        
        sourceTextField.delegate = self
        sourceTextField.text = sourceLocation?.name
        sourceTextField.addTarget(self, action: #selector(updateSearchResults(_:)), for: .editingChanged)
        destinationTextField.delegate = self
        destinationTextField.text = destinationLocation?.name
        destinationTextField.addTarget(self, action: #selector(updateSearchResults(_:)), for: .editingChanged)
        
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        dismissGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissGesture)
        
        dataService.fetchStations().subscribe(onNext: { (station) in
            self.stations.append(station)
        }, onCompleted: {
            var lookupTable: [String: Station] = [:]
            for station in self.stations {
                lookupTable[station.name.lowercased()] = station
            }
            self.searchEngine = SearchEngine(lookupTable: lookupTable)
        }).disposed(by: disposeBag)
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
    
    func updateTextFields() {
        sourceTextField.text = sourceLocation?.name
        destinationTextField.text = destinationLocation?.name
    }
    
    var isSourceBeingEdited: Bool {
        return sourceTextField.isFirstResponder
    }
    
    var isDestinationBeingEdited: Bool {
        return destinationTextField.isFirstResponder
    }
    
    // MARK: Actions

    @IBAction func swapEndpoints(_ sender: Any) {
        
    }
    
    @objc func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc func updateSearchResults(_ sender: UITextField) {
        if let currentText = sender.text, let searchEngine = searchEngine {
            if currentText.isEmpty {
                stations = searchEngine.allValues
            } else {
                stations = searchEngine.searchWith(prefix: currentText.lowercased())
            }
        }
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        stations = searchEngine?.allValues ?? []
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
            return stations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath) as! StationTableViewCell
        if indexPath.section == kSearchLocationSection {
            cell.iconImageView.image = UIImage(named: "location")
            cell.nameLabel.text = "Your location"
            cell.descriptionLabel.text = "Wrocław"
        } else {
            let station = stations[indexPath.row]
            var image: UIImage!
            switch station.category {
            case .bus:
                image = UIImage(named: "bus")
            case .tram:
                image = UIImage(named: "tram")
            case .common:
                image = UIImage(named: "busAndTram")
            }
            cell.iconImageView.image = image
            cell.nameLabel.text = station.name
            cell.descriptionLabel.text = "Station"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == kSearchLocationSection {
            
        } else if indexPath.section == kSearchResultsSection {
            let station = stations[indexPath.row]
            //TODO update text field
        }
        updateTextFields()
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
            parentView.backgroundColor = tableView.backgroundColor
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
