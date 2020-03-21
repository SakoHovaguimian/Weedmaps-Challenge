
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.


import XCTest
@testable import WeedmapsChallenge


class YelpAPIClientTests: XCTestCase {
    
    var business: Business?
    
    let query = "Burgers"
    let lat = "33.602054"
    let long = "-117.901980"

    override func setUp() {
    
        self.business = Business(id: "1-Sako-2-Test",
                                 alias: "Sakos-Tacos",
                                 name: "Sako's Tacos",
                                 distance: 0.142325,
                                 imageURL: "image_url",
                                 rating: 4.5,
                                 price: "$$$$",
                                 url: "www.google.com",
                                 numberOfViews: 34,
                                 isFavorite: true,
                                 coordinates: Coordinate(latitude: 33.602054, longitude: -117.901980))
        
    }

    override func tearDown() {
        self.business = nil
    }

    func testBusinessModelDecodedFromJsonYieldsExpectedResult() {
        
        var data: Data = Data()
    
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(self.business)
            data = jsonData
        } catch {
            XCTFail()
        }
        
        do {
            let jsonDecoder = JSONDecoder()
            let decodedBusiness = try jsonDecoder.decode(Business.self, from: data)
            XCTAssertNotNil(decodedBusiness)
        } catch {
            XCTFail()
        }
        
    }

    func testYelpAPIRequestYieldsExpectedResult() {
        
        YelpService.shared.fetchBusinesses(query: self.query, latitude: self.lat, longitude: self.long) { ( businesses, error) in
            
            XCTAssertNil(error)
            
            guard let unwrappedBusinesses = businesses else {
                XCTFail()
                return
            }

            XCTAssertTrue(!unwrappedBusinesses.isEmpty)
            
        }
        
    }
    
}
