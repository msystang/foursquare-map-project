//
//  foursquare_mapsTests.swift
//  foursquare-mapsTests
//
//  Created by Sunni Tang on 11/4/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import XCTest
@testable import foursquare_maps

class foursquare_mapsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testVenueModelDecode() {
        guard let jsonPath = Bundle.main.path(forResource: "venue", ofType: "json") else {
            XCTFail("Could not find venue.json file")
            return
        }
        
        let jsonURL = URL(fileURLWithPath: jsonPath)
        var venueJSONData = Data()
        
        do {
            venueJSONData = try Data(contentsOf: jsonURL)
        } catch {
            XCTFail("\(error)")
        }
        
        // Act
        var venues = [Venue]()
        
        do {
            let venuesInfo = try Venues.decodeVenuesFromData(from: venueJSONData)
            venues = venuesInfo
        } catch {
            XCTFail("\(error)")
        }
        
        // Assert
        XCTAssertTrue(venues.count == 30, "Was expecting 30 venues, but found \(venues.count)")
    }

    
    func testVenueImageModelDecode() {
        guard let jsonPath = Bundle.main.path(forResource: "venueImage", ofType: "json") else {
            XCTFail("Could not find venueImage.json file")
            return
        }
        
        let jsonURL = URL(fileURLWithPath: jsonPath)
        var venueImageJSONData = Data()
        
        do {
            venueImageJSONData = try Data(contentsOf: jsonURL)
        } catch {
            XCTFail("\(error)")
        }
        
        // Act
        var venueImages = [VenueImage]()
        
        do {
            let venueImagesInfo = try VenueImageResponseWrapper.decodeVenueImagesFromData(from: venueImageJSONData)
            venueImages = venueImagesInfo
        } catch {
            XCTFail("\(error)")
        }
        
        // Assert
        XCTAssertTrue(venueImages.count == 1, "Was expecting 1 venue image, but found \(venueImages.count)")
    }

}
