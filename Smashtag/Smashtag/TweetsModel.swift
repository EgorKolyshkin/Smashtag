//
//  TweetsModel.swift
//  Smashtag
//
//  Created by Егор on 06.10.17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import Foundation

class TweetsModel {
    
    private let limit = 100
    
    private var searches: [String] = ["1","2","3"]
    
    func add(_ search: String){
        if !searches.contains(search)  {
            searches.insert(search, at: 0)
            if searches.count > limit {
                searches.remove(at: limit)
            }
        }
    }
    
    func searchesForTable() -> [String] {
        return self.searches
    }
}
