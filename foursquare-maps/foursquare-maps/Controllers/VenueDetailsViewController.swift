//
//  VenueDetailsViewController.swift
//  foursquare-maps
//
//  Created by Sunni Tang on 11/4/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import UIKit

class VenueDetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var tipTextView: UITextView!
    
    var venue: Venue!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        nameLabel.text = venue.name
        //TODO: add every category
        categoryLabel.text = venue.categories[0].name
        //TODO: add image
        //TODO: add tips
        
        // TODO: Add button
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let addVenueVC = storyboard.instantiateViewController(identifier: "addVenueVC") as AddVenueViewController
        
            addVenueVC.venue = venue
            navigationController?.pushViewController(addVenueVC, animated: true)
    }

}
