//
//  AddVenueViewController.swift
//  foursquare-maps
//
//  Created by Sunni Tang on 11/4/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import UIKit

class AddVenueViewController: UIViewController {

    @IBOutlet weak var collectionNameTextField: UITextField!
    @IBOutlet weak var venueTipTextView: UITextView!
    @IBOutlet weak var addToCollectionCollectionView: UICollectionView!
    
    var venue: Venue!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        venueTipTextView.text = "Enter a tip for \(venue.name)!"
    }
    
    @IBAction func addToCollectionButtonPressed(_ sender: UIBarButtonItem) {
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
