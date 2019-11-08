//
//  Venue.swift
//  foursquare-maps
//
//  Created by Sunni Tang on 11/4/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

// MARK: - Venues
struct Venues: Codable {
    let response: VenueWrapper
    
    static func decodeVenuesFromData(from jsonData: Data) throws -> [Venue] {
        let response = try JSONDecoder().decode(Venues.self, from: jsonData)
        return response.response.venues
    }
    
}

// MARK: - VenueWrapper
struct VenueWrapper: Codable {
    let venues: [Venue]
}

// MARK: - Venue
class Venue: NSObject, Codable, MKAnnotation {
    let id: String
    let name: String
    // TODO: make location optional
    let location: Location
    let categories: [Category]
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
    }
}

// MARK: - Location
struct Location: Codable {
    let lat: Double
    let lng: Double
    let distance: Int
    let formattedAddress: [String]

}

// MARK: - Category
struct Category: Codable {
    let name: String
}
