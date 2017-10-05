//
//  MensionsTableViewController.swift
//  Smashtag
//
//  Created by Егор on 25.09.17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class MensionsTableViewController: UITableViewController {

    var tweet: Tweet? {
        didSet {
            guard let tweet = tweet else { return }
            title = tweet.user.screenName
            mensionSection = setMensionSections(with: tweet)
            tableView.reloadData()
        }
    }
    
    private var image: UIImage?
    
    private var mensionSection: [MensionsSection] = []
    
    private struct MensionsSection {
        var type: String
        var mension: [MentionItem]
    }
    
    private enum MentionItem {
        case keyword(String)
        case image(URL, Double)
    }
    
    private func setMensionSections(with tweet: Tweet) -> [MensionsSection] {
        var mentionSection = [MensionsSection]()
        if tweet.media.count > 0 {
            mentionSection.append(MensionsSection(type: "image", mension: tweet.media.map{MentionItem.image($0.url, $0.aspectRatio)}))
        }
        if tweet.hashtags.count > 0 {
            mentionSection.append(MensionsSection(type: "hashtag", mension: tweet.hashtags.map { MentionItem.keyword($0.keyword)}))
        }
        if tweet.urls.count > 0 {
            mentionSection.append(MensionsSection(type: "urls", mension: tweet.urls.map { MentionItem.keyword($0.keyword)}))
        }
        if tweet.userMentions.count > 0 {
            mentionSection.append(MensionsSection(type: "userMensions", mension: tweet.userMentions.map { MentionItem.keyword($0.keyword)}))
        }
        
        return mentionSection
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return mensionSection.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mensionSection[section].mension.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return mensionSection[section].type
    }
    
    
    // я хз, надо что-то с image делать 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mension = mensionSection[indexPath.section].mension[indexPath.row]
        switch mension {
        case .image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mension = mensionSection[indexPath.section].mension[indexPath.row]
        
        switch mension {
        case .keyword(let keyword):
            let cell = tableView.dequeueReusableCell(withIdentifier: "MensionCell", for: indexPath)
            cell.textLabel?.text = keyword
            return cell
        case .image(let url, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell", for: indexPath)
            if let imageCell = cell as? ImageTableViewCell {
                imageCell.URL = url
            }
            return cell
        }
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "SearchForMension" {
            if let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell){
                if mensionSection[indexPath.section].type == "urls" {
                    if let urlString = cell.textLabel?.text, let url = URL(string: urlString) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                        return false
                    }
                }
            }
            return true
        }
        if identifier == "ShowDetailImage" {
            return true
        }
        return false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchForMension" {
            var destinationViewController = segue.destination
            if let navigationController = destinationViewController as? UINavigationController {
                destinationViewController = navigationController.visibleViewController ?? destinationViewController
            }
            if let tweetTableViewController = destinationViewController as? TweetTableViewController {
                tweetTableViewController.searchText = (sender as? UITableViewCell)?.textLabel?.text
            }
        }
        if segue.identifier == "ShowDetailImage" {
            if let cell = sender as? ImageTableViewCell,
                let indexPath = tableView.indexPath(for: cell){
                    var destinationViewController = segue.destination
                    if let navigationController = destinationViewController as? UINavigationController {
                        destinationViewController = navigationController.visibleViewController ?? destinationViewController
                }
                if let imageViewController = destinationViewController as? ImageViewController {
                    let mension = mensionSection[indexPath.section].mension[indexPath.row]
                    switch mension {
                    case .image(let url, _): imageViewController.imageURL = url
                    default: break
                    }
                }
            }
        }
    }

    
}

