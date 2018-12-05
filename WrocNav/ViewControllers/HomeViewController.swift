//
//  ViewController.swift
//  WrocNav
//
//  Created by Kacper Raczy on 21.11.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import Mapbox

class HomeViewController: WNViewController {
    @IBOutlet weak var mapView: MGLMapView!
    
    private var searchController: UISearchController!
    private let locationManager: CLLocationManager = CLLocationManager()
    private let dataService: DataService = DataService.shared
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        locationManager.delegate = self
        
        mapView.userTrackingMode = .followWithHeading
        mapView.showsUserLocation = true
        mapView.zoomLevel = 13.5
        mapView.styleURL = MGLStyle.lightStyleURL
        mapView.delegate = self
        
        setDataListeners()
    }
    
    // MARK: UI setup
    
    func setUpNavigationBar() {
        guard let navBar = self.navigationController?.navigationBar else {
            return
        }
        
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.tintColor = UIColor.black
        navBar.shadowImage = UIImage()
    }

    // MARK: User Actions
    
    @objc func locate(sender: Any) {
        if let userCoordinates = mapView.userLocation?.coordinate {
            mapView.setCenter(userCoordinates, zoomLevel: 13.5, animated: true)
        }
    }
    
    // Data bindings
    
    func setDataListeners() {
        let annotations = mapView.annotations ?? []
        mapView.removeAnnotations(annotations)
        dataService.fetchStations().map({ (station) -> MGLAnnotation in
            let annotation = MGLPointAnnotation()
            annotation.coordinate = station.coordinates
            annotation.title = station.name
            return annotation
        }).subscribe(onNext: { stationAnnotation in
            self.mapView.addAnnotation(stationAnnotation)
        }, onCompleted: {
            log.info("Successfuly fetched stations.")
        }).disposed(by: disposeBag)
    }

}

extension HomeViewController: MGLMapViewDelegate {

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            // add button for location
            let locateButton = UIBarButtonItem(title: "Locate", style: .plain, target: self, action: #selector(locate(sender:)))
            navigationItem.rightBarButtonItem = locateButton
        }
    }
    
}
