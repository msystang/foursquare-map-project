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

extension MapSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch searchBar.tag {
        case 0:
            searchString = searchText
        case 1:
            //TODO: Add location change here
            break
        default:
            print("textDidChange: Can't find search bar!")
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        searchBar.resignFirstResponder()
        
        //search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            activityIndicator.stopAnimating()
            
            if response == nil {
                print(error)
            } else {
                //remove annotations
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                //get data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                let newAnnotation = MKPointAnnotation()
                newAnnotation.title = searchBar.text
                //TODO: account for optionals
                newAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                self.mapView.addAnnotation(newAnnotation)
                
                //to zoom in the annotation
                let coordinateRegion = MKCoordinateRegion.init(center: newAnnotation.coordinate, latitudinalMeters: self.searchRadius * 2.0, longitudinalMeters: self.searchRadius * 2.0)
                self.mapView.setRegion(coordinateRegion, animated: true)
            }
        }
        
    }
}
