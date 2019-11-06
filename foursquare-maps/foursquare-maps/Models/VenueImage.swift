//
//  VenueImage.swift
//  foursquare-maps
//
//  Created by Sunni Tang on 11/6/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import Foundation

struct VenueImageResponseWrapper: Codable {
    let response: VenueImageResponse
    
    static func decodeVenueImagesFromData(from jsonData: Data) throws -> [VenueImage] {
        let response = try JSONDecoder().decode(VenueImageResponseWrapper.self, from: jsonData)
        return response.response.photos.items
    }
}

struct VenueImageResponse: Codable {
    let photos: VenueImageWrapper
}

struct VenueImageWrapper: Codable {
    let items: [VenueImage]
}

struct VenueImage: Codable {
    let prefix: String
    let suffix: String
    
    //account for optionals?
    var imageUrlStr: String {
       return "\(prefix)original\(suffix)"
    }
    
}
