//
//  Collection.swift
//  foursquare-maps
//
//  Created by Sunni Tang on 11/8/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import Foundation

// MARK: - Collection
struct Collection: Codable {
    let name: String
    let venues: [Venue]?
    //TODO: add image?
}
