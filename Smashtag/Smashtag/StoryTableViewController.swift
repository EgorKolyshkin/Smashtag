//
//  StoryTableViewController.swift
//  Smashtag
//
//  Created by Егор on 07.10.17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class StoryTableViewController: UITableViewController {

    
    private let tweetsModel = TweetsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetsModel.searchesForTable().count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StorySearch", for: indexPath)
        cell.textLabel?.text = tweetsModel.searchesForTable()[indexPath.row]
        return cell
    }

}
