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

struct Venues: Codable {
    let response: VenueWrapper
    
    static func decodeVenuesFromData(from jsonData: Data) throws -> [Venue] {
        let response = try JSONDecoder().decode(Venues.self, from: jsonData)
        return response.response.venues
    }
    
}

struct VenueWrapper: Codable {
    let venues: [Venue]
}

struct Venue: Codable {
    let id: String
    let name: String
    let location: Location
}

class Location: NSObject, Codable, MKAnnotation {
    let lat: Double
    let lng: Double
    let distance: Int
    let formattedAddress: [String]
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
    var hasValidCoordinates: Bool {
        return coordinate.latitude != 0 && coordinate.longitude != 0
    }
}
