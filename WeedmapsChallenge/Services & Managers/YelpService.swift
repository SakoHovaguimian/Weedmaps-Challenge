//
//  YelpService.swift
//  WeedmapsChallenge
//
//  Created by Sako Hovaguimian on 3/19/20.
//  Copyright © 2020 Weedmaps, LLC. All rights reserved.
//

import UIKit
import Alamofire

enum Endpoint: String {
    
    case searchBusinesses = "/businesses/search"
    case searchABusiness = "/businesses"
    
    
    func url(_ base: String, id: String = "") -> URL? {
        let businessToSearchId = id == "" ? "" : "/\(id)"
        return URL(string: base + self.rawValue + businessToSearchId)
    }
    
}

class YelpService {
    
    static let shared = YelpService()
    
    private var apiKey = "2plZWTZ0c1d-fZDQf-T8dvrqVHhwzhb90vo6EDBHtIIrvtLeOooDQ3kHmkiqo3uNJjelvH4dVACeHiRwDhC0HDOfRLRkX3RAQnCd2QGKi1G7ai0sbG_6U14P3b1uXnYx"
    private var clientId = "KVQVAZ2fxLQJt65kH5xG1g"
    
    private let baseURL: String = "https://api.yelp.com/v3"
    
    private var currentRequest: Request?

    //MARK:- API CALL
    
    //MARK: - FETCH BUSINESSES
    func fetchBusinesses(query: String, latitude: String, longitude: String, offset: Int = 0, completion: @escaping ([Business]?, Error?) -> ()) {
        
        guard let url = Endpoint.searchBusinesses.url(baseURL) else { return }
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer " + self.apiKey
        ]
        
        let params: [String : Any] = [
            "location": "502 East Oceanfront Newport Beach, CA",
            "term": query,
            "offset": offset,
            "limit": 15,
            "longitude": longitude,
            "latitude": latitude
        ]
        
        Alamofire.request(url, method: .get, parameters: params, headers: headers).validate().responseJSON { response in
            
            guard response.error == nil else {
                response.error?.localizedDescription == "cancelled" ? completion(nil, nil) : completion(nil, response.error)
                return
            }
            
            guard let data = response.data else { return }
            let businesses = try? JSONDecoder().decode(Businesses.self, from: data)
            
            completion(businesses?.businesses, nil)
            return
        }
        
        
        
        
    }
    
     //MARK: - FETCH A BUSINESS WITH MORE DETAIL (UNUSED IN APP, BUT WILL NEED FOR SCALABILITY)
    func fetchBusiness(withId id: String, completion: @escaping (Business?, Error?) -> ()) {

        guard let url = Endpoint.searchABusiness.url(baseURL, id: id) else { return }
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer " + self.apiKey
        ]
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON { response
            in
            
            guard response.error == nil else {
                response.error?.localizedDescription == "cancelled" ? completion(nil, nil) : completion(nil, response.error)
                return
            }

            guard let data = response.data else { return }
            let business = try! JSONDecoder().decode(Business.self, from: data)
            
            completion(business, nil)

        }
    }
}

