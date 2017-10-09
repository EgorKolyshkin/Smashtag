//
//  TweetsModel.swift
//  Smashtag
//
//  Created by Егор on 06.10.17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import Foundation

class TweetsModel {
    
    private let defaults = UserDefaults.standard
    private let key = "RecentSearches"
    private let limit = 100
    
    var searches: [String]{
        return (defaults.object(forKey: key) as? [String]) ?? []
    }
    
    func add(_ search: String){
        guard !search.isEmpty else { return }
        var newArray = searches.filter { search.caseInsensitiveCompare($0) != .orderedSame}
        newArray.insert(search, at: 0)
        while newArray.count > limit {
            newArray.removeLast()
        }
        defaults.set(newArray, forKey: key)
    }
    
}
