//
//  VenueImageAPIClient.swift
//  foursquare-maps
//
//  Created by Sunni Tang on 11/6/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import Foundation

class VenueImageAPIClient {
    
    // MARK: - Static Properties
    
    static let manager = VenueImageAPIClient()
    
    // MARK: - Instance Methods
    
    static func getImageResultsURLStr(for venue: Venue) -> String {
       return "https://api.foursquare.com/v2/venues/\(venue.id)/photos?client_id=\(Secrets.foursquareClientID)&client_secret=\(Secrets.foursquareSecret)&v=20180323&limit=5"
    }
    
    func getVenueImages(urlStr: String, completionHandler: @escaping (Result<[VenueImage], AppError>) -> ())  {
        
        guard let url = URL(string: urlStr) else {
            print(AppError.badURL)
            return
        }
        
        NetworkManager.manager.performDataTask(withUrl: url, andMethod: .get) { (results) in
            switch results {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let VenueImageInfo = try VenueImageResponseWrapper.decodeVenueImagesFromData(from: data)
                    completionHandler(.success(VenueImageInfo))
                }
                catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
                
            }
        }
    }
    
    // MARK: - Private Properties and Initializers
    
    private init() {}
}
