//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import Foundation

struct Businesses: Codable {
    var businesses: [Business] = []
}


struct Business: Codable {
    
    var id: String
    var alias: String
    var name: String
    var distance: Double?
    var imageURL: String
    var rating: Double?
    var price: String?
    var url: String?
    
    var numberOfViews: Int?
    var isFavorite: Bool?
    
    var coordinates: Coordinate
    
    private enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case alias
        case distance
        case imageURL = "image_url"
        case rating
        case price
        case coordinates
        case url
        case numberOfViews
        case isFavorite
        
    }
    
    public func isBusinessFavorited(_ businesses: [Business]) -> Bool{
        return !businesses.filter({ $0.id == self.id}).isEmpty ? true : false
    }
    
}

struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
}
