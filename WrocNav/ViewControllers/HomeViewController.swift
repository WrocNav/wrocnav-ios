//
//  ViewController.swift
//  WrocNav
//
//  Created by Kacper Raczy on 21.11.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import Mapbox

class HomeViewController: WNViewController {
    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: 40.74699, longitude: -73.98742), animated: false)
        mapView.styleURL = MGLStyle.lightStyleURL
    }
    
    func setUpNavigationBar() {
        guard let navBar = self.navigationController?.navigationBar else {
            return
        }
        
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.tintColor = UIColor.black
        navBar.shadowImage = UIImage()
    }

}
