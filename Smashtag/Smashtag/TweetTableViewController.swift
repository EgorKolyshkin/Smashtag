//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by CS193p Instructor on 2/8/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate
{
    // MARK: Model

    private var tweets = [Array<Twitter.Tweet>]()
    
    private let tweetsModel = TweetsModel()
    
    var searchText: String? {
        didSet {
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
            lastTwitterRequest = nil
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
            tweetsModel.add(searchText!)
            if let search = searchText {
                tweetsModel.add(search)
            }
        }
    }
    
    // MARK: Updating the Table
    
    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: "\(query) -filter:safe -filter:retweets",
                                    count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest: Twitter.Request?

    private func searchForTweets() {
        if let request = lastTwitterRequest?.newer ?? twitterRequest() {
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                DispatchQueue.main.async {
                    if request == self?.lastTwitterRequest {
                        self?.tweets.insert(newTweets, at:0)
                        self?.tableView.insertSections([0], with: .fade)
                    }
                    self?.refreshControl?.endRefreshing()
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    

    @IBAction func refresh(_ sender: UIRefreshControl) {
        searchForTweets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // we use the row height in the storyboard as an "estimate"
        tableView.estimatedRowHeight = tableView.rowHeight
        // but use whatever autolayout says the height should be as the actual row height
        tableView.rowHeight = UITableViewAutomaticDimension
        // the row height could alternatively be set
        // using the UITableViewDelegate method heightForRowAt
    }
    
    // MARK: Search Text Field

    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = searchTextField.text
        }
        return true
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)

        // get the tweet that is associated with this row
        // that the table view is asking us to provide a UITableViewCell for
        let tweet: Tweet = tweets[indexPath.section][indexPath.row]

        // Configure the cell...
        // the textLabel and detailTextLabel are for non-Custom cells
//        cell.textLabel?.text = tweet.text
//        cell.detailTextLabel?.text = tweet.user.name
        
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        return "\(tweets.count-section)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let mensionsTableViewController = destination as? MensionsTableViewController,
            let tweetCell = sender as? TweetTableViewCell {
            mensionsTableViewController.tweet = tweetCell.tweet
        }
    }
}
