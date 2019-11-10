//
//  PersistenceManager.swift
//  foursquare-maps
//
//  Created by Sunni Tang on 11/8/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import Foundation

class PersistenceManager<T: Codable> {
    
    // MARK: - Instance Methods
    func getObjectsFromFileManager() throws -> [T] {
        guard let data = FileManager.default.contents(atPath: url.path) else {
            return []
        }
        return try PropertyListDecoder().decode([T].self, from: data)
    }
    
    func save(newObject: T) throws {
        var objectsFromFileManager = try getObjectsFromFileManager()
        objectsFromFileManager.append(newObject)
        let serializedData = try PropertyListEncoder().encode(objectsFromFileManager)
        try serializedData.write(to: url, options: Data.WritingOptions.atomic)
    }
    
    // MARK: - Initializers
    init(fileName: String) {
        self.fileName = fileName
    }
    
    // MARK: - Private Properties
    private let fileName: String
    
    private var url: URL {
        return filePathFromDocumentsDirectory(filename: fileName)
    }
    
    // MARK: - Private Functions
    private func documentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func filePathFromDocumentsDirectory(filename: String) -> URL {
        return documentsDirectory().appendingPathComponent(filename)
    }
}
