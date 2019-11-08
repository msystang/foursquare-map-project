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

}

extension AddVenueViewController: UICollectionViewDelegateFlowLayout {}

extension AddVenueViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}
