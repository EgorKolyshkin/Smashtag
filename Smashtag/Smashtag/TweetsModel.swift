//
//  TweetsModel.swift
//  Smashtag
//
//  Created by Егор on 06.10.17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import Foundation

class TweetsModel {
    
    private static let defaults = UserDefaults.standard
    private static let key = "RecentSearches"
    private static let limit = 100
    
    static var searches: [String] = {
        return (defaults.object(forKey: key) as? [String]) ?? []
    }()
    
    static func add(_ search: String){
        if !searches.contains(search)  {
            searches.insert(search, at: 0)
            if searches.count > limit {
                searches.remove(at: limit)
            }
        }
    }
}
