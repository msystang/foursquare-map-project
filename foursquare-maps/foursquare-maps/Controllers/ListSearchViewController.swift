//
//  ListSearchViewController.swift
//  foursquare-maps
//
//  Created by Sunni Tang on 11/4/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import UIKit

class ListSearchViewController: UIViewController {

    @IBOutlet weak var listSearchTableView: UITableView!
    
    var venues = [Venue]() {
        didSet {
            listSearchTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listSearchTableView.delegate = self
        listSearchTableView.dataSource = self
    }
    
}

extension ListSearchViewController: UITableViewDelegate {
    
}


extension ListSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listSearchTableView.dequeueReusableCell(withIdentifier: "listSearchCell", for: indexPath) as! ListSearchTableViewCell
        let venue = venues[indexPath.row]
        
        cell.nameLabel.text = venue.name
        //TODO Print every category in array
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
