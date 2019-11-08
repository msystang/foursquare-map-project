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
    
    var collections = [Collection]() {
        didSet {
            addToCollectionCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        venueTipTextView.text = "Enter a tip for \(venue.name)!"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadCollections()
    }
    
    @IBAction func addToCollectionButtonPressed(_ sender: UIBarButtonItem) {
    
    }

    private func setUpCollectionView() {
        addToCollectionCollectionView.delegate = self
        addToCollectionCollectionView.dataSource = self
    }
    
    private func loadCollections() {
        do {
            collections = try CollectionPersistenceHelper.manager.get()
        } catch {
            print("Can't load collections")
        }
    }
}

extension AddVenueViewController: UICollectionViewDelegateFlowLayout {}

extension AddVenueViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addVenueCell", for: indexPath) as! AddVenueCollectionViewCell
        let collection = collections[indexPath.row]
        
        cell.venueNameLabel.text = collection.name
        //add cell image
        
        return cell
    }
    
    
}
