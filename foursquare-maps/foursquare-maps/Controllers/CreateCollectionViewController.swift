//
//  CreateCollectionViewController.swift
//  foursquare-maps
//
//  Created by Sunni Tang on 11/4/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import UIKit

class CreateCollectionViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionNameTextField: UITextField!
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBAction Functions
    @IBAction func createButtonPressed(_ sender: UIBarButtonItem) {
        //TODO: account for empty strings
        if let name = collectionNameTextField.text {
            
            let newCollection = Collection(name: name, venues: nil)
            
            do {
                try CollectionPersistenceHelper.manager.save(newCollection: newCollection)
            } catch {
                
            }
        } else {
            //alert
        }
    }
    

}
