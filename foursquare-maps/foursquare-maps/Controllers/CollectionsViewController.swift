//
//  CollectionsViewController.swift
//  foursquare-maps
//
//  Created by Sunni Tang on 11/4/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import UIKit

class CollectionsViewController: UIViewController {

    @IBOutlet weak var collectionsCollectionView: UICollectionView!
    
    var collections = [Collection]() {
        didSet {
            collectionsCollectionView.reloadData()
        }
    }
    
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
    
    private func setUpCollectionView() {
        collectionsCollectionView.dataSource = self
        collectionsCollectionView.delegate = self
    }
}

extension CollectionsViewController: UICollectionViewDelegateFlowLayout {
    
}

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
    
    
    
}
