//
//  DatabaseManager.swift
//  WeedmapsChallenge
//
//  Created by Sako Hovaguimian on 3/20/20.
//  Copyright © 2020 Weedmaps, LLC. All rights reserved.
//

import UIKit

class CacheManager {
    
    static let shared = CacheManager()
    
    private var businessesKey = "businesses"
    private var searchKey = "searches"
    
    //MARK: RECENT SEARCHES
    public func fetchCachedSearches() -> [String] {
        
        if let searchData = UserDefaults.standard.data(forKey: self.searchKey) {
            
            let searches = try? JSONDecoder().decode([String].self, from: searchData)
            
            return searches ?? []
        }
            
        return []
    }

    public func cacheSearch(_ search: String) {
        
        var recentSearches = self.fetchCachedSearches()
        recentSearches.append(search)
        
        if let encoded = try? JSONEncoder().encode(recentSearches) {
            UserDefaults.standard.set(encoded, forKey: self.searchKey)
        }
        
         print("💿💿💿💿💿💿 Successfully saved \(search) to recent searches on disk")
        
    }
    
    
    
    //MARK: FAVORITES
    public func cacheBusiness(_ business: Business) {
        
        var cachedBusinesses = self.fetchCachedBusinesses()
        
        if cachedBusinesses.filter({ $0.id == business.id }).count == 0 {
            var favBusiness = business
            favBusiness.isFavorite = true
            favBusiness.numberOfViews = 0
            cachedBusinesses.append(favBusiness)
            
             print("💿💿💿💿💿💿 Successfully favorited & saved \(business.name) to disk")
        }

        if let encoded = try? JSONEncoder().encode(cachedBusinesses) {
            UserDefaults.standard.set(encoded, forKey: self.businessesKey)
        }
        
    }
    
    public func fetchCachedBusinesses() -> [Business] {
        
        if let businessData = UserDefaults.standard.data(forKey: self.businessesKey) {
            
            let businesses = try? JSONDecoder().decode([Business].self, from: businessData)
                
            return businesses ?? []
        }
            
        return []
    }
    
    public func removeCachedBusiness(_ business: Business) {
        
        var cachedBusinesses = self.fetchCachedBusinesses()
        
        if let row = cachedBusinesses.firstIndex(where: {$0.id == business.id}) {
            cachedBusinesses.remove(at: row)
        }
        
        print("💿💿💿💿💿💿 Successfully removed \(business.name) from disk")
                 
        if let encoded = try? JSONEncoder().encode(cachedBusinesses) {
            UserDefaults.standard.set(encoded, forKey: self.businessesKey)
        }
        
    }
    
    public func updateCachedBusiness(_ business: Business) {
        
        var cachedBusinesses = self.fetchCachedBusinesses()
        
        if let row = cachedBusinesses.firstIndex(where: {$0.id == business.id}) {
            cachedBusinesses[row].numberOfViews = (cachedBusinesses[row].numberOfViews ?? 0) + 1
            
            print("💿💿💿💿💿💿 Successfully incremented \(business.name) to number of visits \(cachedBusinesses[row].numberOfViews ?? 0)")
        }
                 
        if let encoded = try? JSONEncoder().encode(cachedBusinesses) {
            UserDefaults.standard.set(encoded, forKey: self.businessesKey)
        }
        
    }
    
    
}
