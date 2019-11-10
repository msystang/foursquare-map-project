//
//  CollectionsViewController.swift
//  foursquare-maps
//
//  Created by Sunni Tang on 11/4/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import UIKit

class CollectionsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionsCollectionView: UICollectionView!
    
    // MARK: - Internal Properties
    var collections = [Collection]() {
        didSet {
            collectionsCollectionView.reloadData()
        }
    }
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            collections = try CollectionPersistenceHelper.manager.get()
        } catch {
            //TODO: error alert?
            print("can't load collections")
        }
    }
    
    // MARK: - Private Methods
    private func setUpCollectionView() {
        collectionsCollectionView.dataSource = self
        collectionsCollectionView.delegate = self
    }
}

// MARK: - CollectionView Delegate Methods
extension CollectionsViewController: UICollectionViewDelegateFlowLayout {
    
}

// MARK: - CollectionView Data Source Methods
extension CollectionsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionsCell", for: indexPath) as! CollectionsCollectionViewCell
        let collection = collections[indexPath.row]
        
        cell.collectionNameLabel.text = collection.name
        // TODO: assign image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let listSearchVC = storyboard.instantiateViewController(identifier: "listSearchVC") as ListSearchViewController
        
        let collection = collections[indexPath.row]
        
        if let venues = collection.venues {
            listSearchVC.venues = venues
            
//            TODO: hide nav bar from here?
            // listSearchVC.navigationController?.navigationBar.isHidden = true
            navigationController?.pushViewController(listSearchVC, animated: true)
        } else {
            //alert
            print("no venues saved in this collection yet")
        }
    }
    
    
}
