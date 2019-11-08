//
//  CreateCollectionViewController.swift
//  foursquare-maps
//
//  Created by Sunni Tang on 11/4/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import UIKit

class CreateCollectionViewController: UIViewController {

    @IBOutlet weak var collectionNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
