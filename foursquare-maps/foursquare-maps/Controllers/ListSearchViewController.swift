//
//  ListSearchViewController.swift
//  foursquare-maps
//
//  Created by Sunni Tang on 11/4/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import UIKit

class ListSearchViewController: UIViewController {
    //TODO: Print every category in array?
    
    // MARK: - IB Outlets
    @IBOutlet weak var listSearchTableView: UITableView!
    
    // MARK: - Internal Properties
    var venues = [Venue]()
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        listSearchTableView.delegate = self
        listSearchTableView.dataSource = self
        
        listSearchTableView.reloadData()
    }
    
}

// MARK: - TableView Delegate Methods
extension ListSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let venueDetailsVC = storyboard.instantiateViewController(identifier: "venueDetailsVC") as VenueDetailsViewController
        
        let venue = venues[indexPath.row]
        
        venueDetailsVC.venue = venue
        navigationController?.pushViewController(venueDetailsVC, animated: true)
    }
}

// MARK: - TableView Data Source Methods
extension ListSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = listSearchTableView.dequeueReusableCell(withIdentifier: "listSearchCell", for: indexPath) as? ListSearchTableViewCell else { return UITableViewCell() }
        
        let venue = venues[indexPath.row]
        
        cell.nameLabel.text = venue.name
        
        cell.categoryLabel.text = venue.categories[0].name
        
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
                                            cell.venueImageView.image = imageFromUrl
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
