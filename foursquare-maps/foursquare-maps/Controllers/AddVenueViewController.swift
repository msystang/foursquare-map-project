//
//  AddVenueViewController.swift
//  foursquare-maps
//
//  Created by Sunni Tang on 11/4/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import UIKit

class AddVenueViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionNameTextField: UITextField!
    @IBOutlet weak var venueTipTextView: UITextView!
    @IBOutlet weak var addToCollectionCollectionView: UICollectionView!
    
    
    // TODO: check to see if it's already saved in a specific category when saving
    // MARK: - Internal Properties
    var venue: Venue!
    
    var collections = [Collection]() {
        didSet {
            addToCollectionCollectionView.reloadData()
        }
    }
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        venueTipTextView.text = "Enter a tip for \(venue.name)!"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadCollections()
    }
    
    // MARK: - IBAction Functions
    @IBAction func addToCollectionButtonPressed(_ sender: UIBarButtonItem) {
        if let name = collectionNameTextField.text {
            do {
                let newCollection = Collection(name: name, venues: [venue])
                try CollectionPersistenceHelper.manager.save(newCollection: newCollection)
                loadCollections()
                //TODO: show alert & pop?
                print("saved")
            } catch {
                print(error)
            }
        }
    }

    // MARK: - Private Functions
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

// MARK: - CollectionView Delegate Methods
extension AddVenueViewController: UICollectionViewDelegateFlowLayout {}

// MARK: - CollectionView DataSource Methods
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collection = collections[indexPath.row]
        
        do {
            // TODO: edit persistence manager to replace old collection with new collection + venue
        } catch {
            
        }
    }
    
}
