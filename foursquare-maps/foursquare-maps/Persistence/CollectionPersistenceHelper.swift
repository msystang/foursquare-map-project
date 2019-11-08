//
//  CollectionPersistenceHelper.swift
//  foursquare-maps
//
//  Created by Sunni Tang on 11/8/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import Foundation

class CollectionPersistenceHelper {
    // MARK: - Static Properties
    static let manager = CollectionPersistenceHelper()
    
    // MARK: - Instance Methods
    func save(newCollection: Collection) throws {
        try persistenceHelper.save(newObject: newCollection)
    }
    
    func get() throws -> [Collection] {
        return try persistenceHelper.getObjectsFromFileManager()
    }
    
    // MARK: - Initializers and Private Properties
    private let persistenceHelper = PersistenceManager<Collection>(fileName: "Collection.plist")
    
    private init() {}
}
