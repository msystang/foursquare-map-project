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
    var venues = [Venue]() {
        didSet {
            addMapAnnotations(venues: venues)
            venueImageCollectionView.reloadData()
        }
    }
    
    var searchString: String? = nil {
        didSet {
            loadVenues()
            addMapAnnotations(venues: venues)
            venueImageCollectionView.reloadData()
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
//    @IBAction func listButtonPressed(_ sender: UIButton) {
//        let listSearchVC = ListSearchViewController()
//        listSearchVC.venues = venues
//
//        navigationController?.pushViewController(listSearchVC, animated: true)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else { fatalError("No identifier in segue")}
        
        if segueIdentifier == "mapToListSegue" {
            if let listSearchVC = segue.destination as? ListSearchViewController {
                listSearchVC.venues = venues
            }
        }
    }
    
    // MARK: - Private Functions
    private func setDelegates() {
        locationManager.delegate = self
        mapView.delegate = self
        venueSearchBar.delegate = self
        locationSearchBar.delegate = self
        venueImageCollectionView.delegate = self
        venueImageCollectionView.dataSource = self
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

    private func loadVenues() {
        let urlStr = VenueAPIClient.getSearchResultsURLStr(from: initialLocation.coordinate.latitude, longitude: initialLocation.coordinate.longitude, searchString: searchString ?? "")
        
        VenueAPIClient.manager.getVenues(urlStr: urlStr) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    // TODO: Make alert?
                    print(error)
                case .success(let venuesFromUrl):
                    self.venues = venuesFromUrl
                }
            }
        }
    }
    
    
    private func addMapAnnotations(venues: [Venue]) {
        for venue in venues {
            let annotation: MKPointAnnotation = {
                let annotation = MKPointAnnotation()
                annotation.title = venue.name
                annotation.coordinate = venue.coordinate
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

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        switch searchBar.tag {
        case 0:
            searchString = searchBar.text
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
        
        // TODO: update search request based on which search bar was used
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
                self.loadVenues()
                
            }
        }
        
    }
}

extension MapSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return venues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "venueImageCell", for: indexPath) as! VenueImageCollectionViewCell
        let venue = venues[indexPath.row]
        
        let venueImageResultsUrlStr = VenueImageAPIClient.getImageResultsURLStr(for: venue)
        print(venueImageResultsUrlStr)
        
        VenueImageAPIClient.manager.getVenueImages(urlStr: venueImageResultsUrlStr) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let venueImageResultsFromUrl):
                    if !venueImageResultsFromUrl.isEmpty {
                        
                        let result = venueImageResultsFromUrl[0]
                        let urlStr = result.imageUrlStr
                        print(urlStr)
                        
                        ImageHelper.manager.getImage(urlStr: urlStr) { (result) in
                            DispatchQueue.main.async {
                                switch result {
                                case .failure(let error):
                                    print(error)
                                case .success(let imageFromUrl):
                                    cell.imageView.image = imageFromUrl
                                    // TODO: adjust image scale
                                }
                            }
                        }
                    }
                }
                
            }
        }
        
        return cell
    }
    
    
}

extension MapSearchViewController: UICollectionViewDelegateFlowLayout {
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
}
