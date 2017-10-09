//
//  StoryTableViewController.swift
//  Smashtag
//
//  Created by Егор on 07.10.17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class StoryTableViewController: UITableViewController {

    
    let tweetsModel = TweetsModel()
    
    var recentSearches: [String] {
        return tweetsModel.searches
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        tableView.reloadData()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recentSearches.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StorySearch", for: indexPath)
        cell.textLabel?.text = tweetsModel.searches[indexPath.row]
        return cell
    }

}
