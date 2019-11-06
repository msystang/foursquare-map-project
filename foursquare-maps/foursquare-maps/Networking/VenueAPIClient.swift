//
//  VenueAPIClient.swift
//  foursquare-maps
//
//  Created by Sunni Tang on 11/5/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import Foundation

class VenueAPIClient {
    
    // MARK: - Static Properties
    
    static let manager = VenueAPIClient()
    
    // MARK: - Instance Methods
    
    static func getSearchResultsURLStr(from latitude: Double, longitude: Double, searchString: String) -> String {
        return "https://api.foursquare.com/v2/venues/search?client_id=\(Secrets.foursquareClientID)&client_secret=\(Secrets.foursquareSecret)&v=20180323&ll=\(latitude),\(longitude)&query=\(searchString)&limit=49"
    }
    
    func getVenues(urlStr: String, completionHandler: @escaping (Result<[Venue], AppError>) -> ())  {
        
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
                    let VenueInfo = try Venues.decodeVenuesFromData(from: data)
                    completionHandler(.success(VenueInfo))
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
