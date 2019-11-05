//
//  ViewController.swift
//  foursquare-maps
//
//  Created by Sunni Tang on 11/4/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapSearchViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var venueSearchBar: UISearchBar!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var venueImageCollectionView: UICollectionView!
    
    // MARK: - Private Properties
    private let locationManager = CLLocationManager()
    private let initialLocation = CLLocation(latitude: 40.742054, longitude: -73.769417)
    private let searchRadius: CLLocationDistance = 2000
    
    // MARK: - Computed Properties
    private var venues = [Venue]() {
        didSet {
            addMapAnnotations(venues: venues)
        }
    }
    
    var searchString: String? = nil {
        didSet {
            addMapAnnotations(venues: venues)
        }
    }
    
    // MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        getLocationAuthorization()
        setMapProperties()
    }
    
    // MARK: - IBAction Methods
    @IBAction func listButtonPressed(_ sender: UIButton) {
    }
    
    
    // MARK: - Private Functions
    private func setDelegates() {
        locationManager.delegate = self
        mapView.delegate = self
    }
    
    private func setMapProperties() {
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    private func getLocationAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.requestLocation()
                locationManager.startUpdatingLocation()
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
            default:
                locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func addMapAnnotations(venues: [Venue]) {
        for venue in venues {
            let annotation: MKPointAnnotation = {
                let annotation = MKPointAnnotation()
                annotation.title = venue.name
                annotation.coordinate = CLLocationCoordinate2D(latitude: venue.location.lat, longitude: venue.location.lng)
                return annotation
            }()
            
            mapView.addAnnotation(annotation)
        }
    }
    
    
}


extension MapSearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("New locations: \(locations)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("An error occured: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed to: \(status.rawValue)")
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            break
        }
    }
    
}

extension MapSearchViewController: MKMapViewDelegate {
    
}
