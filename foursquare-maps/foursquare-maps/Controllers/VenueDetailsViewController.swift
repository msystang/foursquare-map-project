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
    
    var venue: Venue! {
        didSet{
//            nameLabel.text = venue.name
//                   //TODO: add every category
//            categoryLabel.text = venue.categories[0].name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        //TODO: add image
        //TODO: add textview functionality
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.text = venue.name
               //TODO: add every category
               categoryLabel.text = venue.categories[0].name
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
