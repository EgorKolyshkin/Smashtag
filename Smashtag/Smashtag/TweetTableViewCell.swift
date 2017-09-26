//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor on 2/8/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell
{
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    var tweet: Twitter.Tweet? { didSet { updateUI() } }
    
    private func updateUI() {
        tweetTextLabel?.attributedText = setTextLabel(tweet)
        tweetUserLabel?.text = tweet?.user.description
        
        if let profileImageURL = tweet?.user.profileImageURL {
            DispatchQueue.global(qos: .userInitiated).async { [ weak self ] in
                    if let imageData = try? Data(contentsOf: profileImageURL) {
                        DispatchQueue.main.async {
                        self?.tweetProfileImageView?.image = UIImage(data: imageData)
                    }
                }
            }
        } else {
            tweetProfileImageView?.image = nil
        }
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }
    
    private func setTextLabel(_ tweet: Tweet?) -> NSMutableAttributedString {
        guard let tweet = tweet else { return NSMutableAttributedString(string: "")}
        
        let attributedText = NSMutableAttributedString(string: tweet.text as String)
        
        attributedText.setMensionsColor(tweet.hashtags, color: UIColor.gray)
        attributedText.setMensionsColor(tweet.urls, color: UIColor.blue)
        attributedText.setMensionsColor(tweet.userMentions, color: UIColor.purple)
        
        return attributedText
    }
    
}

private extension NSMutableAttributedString {
    func setMensionsColor(_ mensions: [Mention], color: UIColor) {
        for mension in mensions {
            addAttribute(NSForegroundColorAttributeName, value: color, range: mension.nsrange)
        }
    }
}












