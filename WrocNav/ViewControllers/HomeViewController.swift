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
    var searchBox: SearchBox!
    
    private let locationManager: CLLocationManager = CLLocationManager()
    private let dataService: DataService = DataService.shared
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpSearchBox()
        locationManager.delegate = self
        
        let defaultCoordinates = CLLocationCoordinate2D(latitude: 51.111983, longitude: 17.061557)
        mapView.setCenter(defaultCoordinates, zoomLevel: 10.0, animated: false)
        mapView.userTrackingMode = .followWithHeading
        mapView.showsUserLocation = true
        mapView.compassView.isHidden = true
        mapView.allowsRotating = false
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
    
    func setUpSearchBox() {
        searchBox = SearchBox()
        searchBox.addTarget(self, action: #selector(search(sender:)), for: .touchUpInside)
        searchBox.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchBox)
        let top = searchBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12.0)
        let leading = searchBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0)
        let trailing = searchBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0)
        NSLayoutConstraint.activate([top, leading, trailing])
    }

    // MARK: User Actions
    
    @objc func locate(sender: Any) {
        if let userCoordinates = mapView.userLocation?.coordinate {
            mapView.setCenter(userCoordinates, zoomLevel: 13.5, animated: true)
        }
    }
    
    @objc func search(sender: SearchBox) {
        sender.isEnabled = false
        performSegue(withIdentifier: "seachSegue", sender: nil)
        sender.isEnabled = true
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
